
;; FlowStack: Continuous Payment Streaming on Stacks
;; Version: 1.0.0

;; --------------------------------------------------------------------------
;; Constants & Errors
;; --------------------------------------------------------------------------

(define-constant CONTRACT-OWNER tx-sender)

(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-INVALID-PARAMS (err u101))
(define-constant ERR-STREAM-NOT-FOUND (err u102))
(define-constant ERR-STREAM-ALREADY-CANCELLED (err u103))
(define-constant ERR-CLIFF-NOT-REACHED (err u104))
(define-constant ERR-INSUFFICIENT-FUNDS (err u105))

;; --------------------------------------------------------------------------
;; Data Maps & Vars
;; --------------------------------------------------------------------------

(define-data-var last-stream-id uint u0)

(define-map streams
  uint
  {
    sender: principal,
    recipient: principal,
    total-amount: uint,
    start-block: uint,
    end-block: uint,
    rate-per-block: uint,
    withdrawn: uint,
    cancelled: bool,
    cancellable: bool,
    cliff-block: uint
  }
)

;; --------------------------------------------------------------------------
;; Read-Only Functions
;; --------------------------------------------------------------------------

(define-read-only (get-stream (stream-id uint))
  (map-get? streams stream-id)
)

(define-read-only (calculate-available (stream-id uint))
  (let
    (
      (stream (unwrap! (map-get? streams stream-id) u0))
      (current-block block-height)
    )
    (if (or (get cancelled stream) (< current-block (get start-block stream)))
      u0
      (let
        (
          (end-point (if (> current-block (get end-block stream)) (get end-block stream) current-block))
          (elapsed (- end-point (get start-block stream)))
          (accrued (* elapsed (get rate-per-block stream)))
          (available (if (> accrued (get withdrawn stream)) (- accrued (get withdrawn stream)) u0))
        )
        (if (< current-block (get cliff-block stream))
          u0
          (if (> (+ (get withdrawn stream) available) (get total-amount stream))
            (- (get total-amount stream) (get withdrawn stream))
            available
          )
        )
      )
    )
  )
)

;; --------------------------------------------------------------------------
;; Public Functions
;; --------------------------------------------------------------------------

(define-public (create-stream (recipient principal) (amount uint) (duration uint) (cancellable bool) (cliff-delta uint))
  (let
    (
      (stream-id (+ (var-get last-stream-id) u1))
      (start-block block-height)
      (end-block (+ start-block duration))
      (rate (/ amount duration))
      (cliff-block (+ start-block cliff-delta))
    )
    ;; Assertions
    (asserts! (> amount u0) ERR-INVALID-PARAMS)
    (asserts! (> duration u0) ERR-INVALID-PARAMS)
    (asserts! (not (is-eq recipient tx-sender)) ERR-INVALID-PARAMS)
    
    ;; Transfer funds to contract
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
    
    ;; Store stream data
    (map-set streams stream-id {
      sender: tx-sender,
      recipient: recipient,
      total-amount: amount,
      start-block: start-block,
      end-block: end-block,
      rate-per-block: rate,
      withdrawn: u0,
      cancelled: false,
      cancellable: cancellable,
      cliff-block: cliff-block
    })
    
    ;; Increment ID and return
    (var-set last-stream-id stream-id)
    (print { event: "stream-created", stream-id: stream-id, sender: tx-sender, recipient: recipient })
    (ok stream-id)
  )
)

(define-public (withdraw (stream-id uint))
  (let
    (
      (stream (unwrap! (map-get? streams stream-id) ERR-STREAM-NOT-FOUND))
      (available (calculate-available stream-id))
    )
    ;; Checks
    (asserts! (is-eq tx-sender (get recipient stream)) ERR-NOT-AUTHORIZED)
    (asserts! (> available u0) ERR-INSUFFICIENT-FUNDS)
    
    ;; Transfer funds from contract to recipient
    (try! (as-contract (stx-transfer? available tx-sender (get recipient stream))))
    
    ;; Update stream data
    (map-set streams stream-id (merge stream { withdrawn: (+ (get withdrawn stream) available) }))
    
    (print { event: "withdrawal", stream-id: stream-id, recipient: tx-sender, amount: available })
    (ok available)
  )
)

(define-public (cancel-stream (stream-id uint))
  (let
    (
      (stream (unwrap! (map-get? streams stream-id) ERR-STREAM-NOT-FOUND))
      (streamed (if (get cancelled stream) u0 (+ (get withdrawn stream) (calculate-available stream-id))))
      (refund (- (get total-amount stream) streamed))
    )
    ;; Checks
    (asserts! (is-eq tx-sender (get sender stream)) ERR-NOT-AUTHORIZED)
    (asserts! (get cancellable stream) ERR-NOT-AUTHORIZED)
    (asserts! (not (get cancelled stream)) ERR-STREAM-ALREADY-CANCELLED)
    
    ;; Transfer remaining funds back to sender
    (if (> refund u0)
      (try! (as-contract (stx-transfer? refund (as-contract tx-sender) (get sender stream))))
      u0
    )
    
    ;; Mark as cancelled
    (map-set streams stream-id (merge stream { cancelled: true }))
    
    (print { event: "stream-cancelled", stream-id: stream-id, sender: tx-sender, refund: refund })
    (ok refund)
  )
)
