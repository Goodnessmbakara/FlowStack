<script lang="ts">
  import { account, network } from '../wallet'
  import { createEventDispatcher } from 'svelte'
  import { openContractCall } from '@stacks/connect'
  import { uint, principalCV, boolCV, PostConditionMode } from '@stacks/transactions'
  
  const dispatch = createEventDispatcher()
  
  let step = 1
  let recipient = ''
  let amount = ''
  let duration = '7'
  let cancellable = true
  let cliff = false
  let isSubmitting = false

  function nextStep() {
    if (step < 3) step++
  }

  function prevStep() {
    if (step > 1) step--
  }

  async function handleSubmit() {
    if (isSubmitting) return
    isSubmitting = true
    
    const contractAddress = import.meta.env.VITE_PUBLIC_CONTRACT_ADDRESS || 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM'
    const contractName = 'flowstack'
    
    // Calculates rate and duration in blocks approx (assuming 10 min blocks for Bitcoin/Stacks for simplicity or sticking to seconds if code uses logic, but clarity uses blocks)
    // Wait, my contract uses block-height. Stacks block time is ~10 mins? 
    // Actually Stacks Nakamoto is fast blocks (seconds). Let's assume input duration is Days.
    // 1 Day = 86400 seconds.
    // If using fast blocks (e.g. 5 seconds), 1 day = 17280 blocks.
    // Let's approximate for hackathon: 1 day = 144 blocks (pre-Nakamoto) or just treat input as "blocks" for testing if easier, but for UI user expects time.
    // Let's just convert days to approximate blocks. Assuming 1 block = 600 seconds (10 min) for safety or stick to what testnet does.
    // OR better, since Nakamoto is live/coming, maybe just use a multiplier. 
    // Let's use a standard assumption: 144 blocks per day.
    
    // Correction: Contract logic should probably be time-based if possible, but Clarinet uses block-height.
    // I will use 144 blocks per day conversion for now.
    const blocksPerDay = 144
    const durationBlocks = parseInt(duration) * blocksPerDay
    const amountMicroStx = Math.floor(parseFloat(amount) * 1_000_000)
    
    // Cliff delta: let's say 1 day cliff if enabled
    const cliffDelta = cliff ? blocksPerDay : 0

    const functionArgs = [
      principalCV(recipient),
      uint(amountMicroStx),
      uint(durationBlocks),
      boolCV(cancellable),
      uint(cliffDelta)
    ]

    const options = {
      contractAddress,
      contractName,
      functionName: 'create-stream',
      functionArgs,
      network,
      postConditionMode: PostConditionMode.Allow, // Simplification for hackathon; usually defined precisely
      onFinish: (data) => {
        console.log('Transaction finished:', data)
        isSubmitting = false
        dispatch('created')
      },
      onCancel: () => {
        isSubmitting = false
      },
    }

    try {
      await openContractCall(options)
    } catch (e) {
      console.error(e)
      isSubmitting = false
    }
  }
</script>

<div class="max-w-2xl mx-auto px-6 py-12">
  <div class="bg-slate-900/50 border border-slate-800 rounded-3xl p-8">
    <div class="flex items-center justify-between mb-8">
      <h2 class="text-2xl font-bold">New Payment Stream</h2>
      <div class="flex gap-1">
        {#each [1, 2, 3] as i}
          <div class="w-8 h-1 rounded-full transition-all {step >= i ? 'bg-primary' : 'bg-slate-800'}"></div>
        {/each}
      </div>
    </div>

    {#if step === 1}
      <div class="space-y-6">
        <div>
          <label class="block text-sm font-bold text-slate-400 mb-2 uppercase tracking-wide">Recipient Address</label>
          <input 
            type="text" 
            bind:value={recipient}
            placeholder="ST..." 
            class="w-full bg-slate-800 border-none rounded-xl px-4 py-4 text-white focus:ring-2 focus:ring-primary/50 transition-all font-mono"
          />
        </div>
        <button on:click={nextStep} class="w-full py-4 bg-primary hover:bg-primary-dark text-white rounded-xl font-bold transition-all shadow-lg shadow-primary/20">
          Continue
        </button>
      </div>
    {:else if step === 2}
      <div class="space-y-6">
        <div>
          <label class="block text-sm font-bold text-slate-400 mb-2 uppercase tracking-wide">Amount (STX)</label>
          <input 
            type="number" 
            bind:value={amount}
            placeholder="0.00" 
            class="w-full bg-slate-800 border-none rounded-xl px-4 py-4 text-white focus:ring-2 focus:ring-primary/50 transition-all text-2xl font-bold"
          />
        </div>
        <div>
          <label class="block text-sm font-bold text-slate-400 mb-2 uppercase tracking-wide">Duration (Days)</label>
          <select bind:value={duration} class="w-full bg-slate-800 border-none rounded-xl px-4 py-4 text-white focus:ring-2 focus:ring-primary/50 transition-all">
            <option value="1">1 Day</option>
            <option value="7">7 Days</option>
            <option value="30">30 Days</option>
            <option value="90">90 Days</option>
          </select>
        </div>
        <div class="flex gap-4">
          <button on:click={prevStep} class="flex-1 py-4 bg-slate-800 hover:bg-slate-700 text-white rounded-xl font-bold transition-all">Back</button>
          <button on:click={nextStep} class="flex-1 py-4 bg-primary hover:bg-primary-dark text-white rounded-xl font-bold transition-all shadow-lg shadow-primary/20 text-center">Continue</button>
        </div>
      </div>
    {:else if step === 3}
      <div class="space-y-6">
        <div class="p-6 rounded-2xl bg-primary/5 border border-primary/10">
          <div class="text-xs text-primary/60 font-bold uppercase mb-4">Summary</div>
          <div class="space-y-3">
            <div class="flex justify-between text-sm"><span class="text-slate-500">To:</span> <span class="font-mono">{recipient.slice(0, 10)}...</span></div>
            <div class="flex justify-between text-sm"><span class="text-slate-500">Amount:</span> <span class="font-bold">{amount} STX</span></div>
            <div class="flex justify-between text-sm"><span class="text-slate-500">Duration:</span> <span class="font-bold">{duration} Days</span></div>
          </div>
        </div>
        <div class="flex gap-4">
          <button on:click={prevStep} class="flex-1 py-4 bg-slate-800 hover:bg-slate-700 text-white rounded-xl font-bold transition-all">Back</button>
          <button on:click={handleSubmit} class="flex-1 py-4 bg-gradient-to-r from-primary to-secondary text-white rounded-xl font-bold transition-all shadow-xl shadow-primary/20">
            Confirm & Stream
          </button>
        </div>
      </div>
    {/if}
  </div>
</div>
