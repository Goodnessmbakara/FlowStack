<script lang="ts">
  import LiveBalance from './LiveBalance.svelte'
  import { network, account } from '../wallet'
  import { openContractCall } from '@stacks/connect'
  import { uint, PostConditionMode } from '@stacks/transactions'
  
  export let onBack: () => void
  
  export let stream: any = {
    id: '1',
    sender: 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM',
    recipient: 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG',
    totalAmount: 100,
    ratePerSecond: 0.000165,
    startTime: Math.floor(Date.now() / 1000) - 3600,
    withdrawn: 5.4,
    status: 'active'
  }

  const contractAddress = import.meta.env.VITE_PUBLIC_CONTRACT_ADDRESS || 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM'
  const contractName = 'flowstack'

  async function handleWithdraw() {
    const options = {
      contractAddress,
      contractName,
      functionName: 'withdraw',
      functionArgs: [uint(stream.id)],
      network,
      postConditionMode: PostConditionMode.Allow,
      onFinish: (data) => {
        console.log('Withdrawal submitted:', data)
      },
    }
    await openContractCall(options)
  }

  async function handleCancel() {
    const options = {
      contractAddress,
      contractName,
      functionName: 'cancel-stream',
      functionArgs: [uint(stream.id)],
      network,
      postConditionMode: PostConditionMode.Allow,
      onFinish: (data) => {
        console.log('Cancellation submitted:', data)
      },
    }
    await openContractCall(options)
  }
</script>

<div class="max-w-4xl mx-auto px-6 py-12">
  <button 
    on:click={onBack}
    class="mb-8 text-slate-400 hover:text-white transition-colors flex items-center gap-2 text-sm"
  >
    ← Back to Dashboard
  </button>

  <div class="bg-slate-900/50 border border-slate-800 rounded-3xl p-8 shadow-2xl">
    <div class="flex items-center justify-between mb-12">
      <div>
        <h2 class="text-2xl font-bold mb-1">Stream #{stream.id}</h2>
        <div class="flex items-center gap-2">
          <span class="w-2 h-2 rounded-full {stream.status === 'active' ? 'bg-green-500 animate-pulse' : 'bg-red-500'}"></span>
          <span class="text-xs font-bold {stream.status === 'active' ? 'text-green-500' : 'text-red-500'} uppercase tracking-widest">{stream.status === 'active' ? 'Active Stream' : 'Inactive'}</span>
        </div>
      </div>
      <div class="text-right">
        <div class="text-slate-500 text-xs uppercase font-bold mb-1">Flow Rate</div>
        <div class="text-lg font-mono font-bold text-primary">{stream.ratePerSecond} STX/s</div>
      </div>
    </div>

    <LiveBalance 
      ratePerSecond={stream.ratePerSecond} 
      startTime={stream.startTime} 
      withdrawn={stream.withdrawn} 
      totalAmount={stream.totalAmount} 
    />

    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mt-12">
      <div class="p-6 rounded-2xl bg-slate-800/50 border border-slate-700/50">
        <div class="text-xs text-slate-500 uppercase font-bold mb-2">Sender</div>
        <div class="font-mono text-sm break-all">{stream.sender}</div>
      </div>
      <div class="p-6 rounded-2xl bg-slate-800/50 border border-slate-700/50">
        <div class="text-xs text-slate-500 uppercase font-bold mb-2">Recipient</div>
        <div class="font-mono text-sm break-all">{stream.recipient}</div>
      </div>
    </div>

    <div class="mt-8 pt-8 border-t border-slate-800 flex items-center justify-center gap-4">
      <button 
        on:click={handleWithdraw}
        class="px-8 py-3 bg-primary hover:bg-primary-dark text-white rounded-xl font-bold transition-all shadow-lg shadow-primary/25 disabled:opacity-50 disabled:cursor-not-allowed"
        disabled={stream.status !== 'active'}
      >
        Withdraw Now
      </button>
      <button 
        on:click={handleCancel}
        class="px-8 py-3 bg-slate-800 hover:bg-red-500/10 hover:text-red-400 hover:border-red-500/20 border border-transparent text-slate-400 rounded-xl font-bold transition-all disabled:opacity-50 disabled:cursor-not-allowed"
        disabled={stream.status !== 'active'}
      >
        Cancel Stream
      </button>
    </div>
  </div>
</div>
