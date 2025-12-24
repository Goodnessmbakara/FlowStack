<script lang="ts">
  import { onMount } from 'svelte'
  
  export let ratePerSecond: number
  export let withdrawn: number = 0
  export let startTime: number
  export let totalAmount: number

  let displayBalance: number = 0
  
  function calculate() {
    const now = Math.floor(Date.now() / 1000)
    const elapsed = Math.max(0, now - startTime)
    const accrued = ratePerSecond * elapsed
    displayBalance = Math.min(accrued - withdrawn, totalAmount - withdrawn)
    if (displayBalance < 0) displayBalance = 0
  }

  onMount(() => {
    calculate()
    const interval = setInterval(calculate, 100) // Update every 100ms for smoothness
    return () => clearInterval(interval)
  })
</script>

<div class="flex flex-col items-center justify-center p-6 border border-primary/20 bg-primary/5 rounded-2xl">
  <div class="text-xs uppercase tracking-widest text-primary/60 font-bold mb-2">Available to Withdraw</div>
  <div class="text-5xl font-black tabular-nums tracking-tighter text-white">
    {displayBalance.toFixed(6)} 
    <span class="text-2xl text-slate-500 font-medium">STX</span>
  </div>
</div>
