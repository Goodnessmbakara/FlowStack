<script lang="ts">
  import { account } from '../wallet'
  import { createEventDispatcher } from 'svelte'
  
  const dispatch = createEventDispatcher()
  
  let step = 1
  let recipient = ''
  let amount = ''
  let duration = '7'
  let cancellable = true
  let cliff = false

  function nextStep() {
    if (step < 3) step++
  }

  function prevStep() {
    if (step > 1) step--
  }

  function handleSubmit() {
    // Logic to call WalletConnect & Stacks contract
    console.log('Creating stream...', { recipient, amount, duration, cancellable, cliff })
    dispatch('created')
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
