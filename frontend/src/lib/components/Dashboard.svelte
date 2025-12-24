<script lang="ts">
  import { account } from '../wallet'
  
  let incomingStreams = []
  let outgoingStreams = []
  
  // Mock data for UI development
  $: if (incomingStreams.length === 0) {
    incomingStreams = [{
      id: '1',
      sender: 'ST123...456',
      rate: '0.00012',
      available: '45.2',
      progress: 65,
      status: 'active'
    }]
  }
</script>

<div class="max-w-6xl mx-auto px-6 py-12">
  <div class="flex items-center justify-between mb-12">
    <div>
      <h2 class="text-3xl font-bold mb-2">My Dashboard</h2>
      <p class="text-slate-400">Manage your incoming and outgoing payment streams.</p>
    </div>
    <button class="px-6 py-3 bg-white text-slate-950 rounded-xl font-bold hover:bg-slate-200 transition-all active:scale-95">
      + Create Stream
    </button>
  </div>

  <div class="grid grid-cols-1 md:grid-cols-2 gap-8 mb-12">
    <div class="p-8 rounded-2xl bg-gradient-to-br from-primary/20 to-transparent border border-primary/20">
      <div class="text-sm font-medium text-primary mb-4">Total Streaming In</div>
      <div class="text-4xl font-bold tracking-tight">45.24 <span class="text-xl text-slate-500 font-medium">STX</span></div>
    </div>
    <div class="p-8 rounded-2xl bg-gradient-to-br from-secondary/20 to-transparent border border-secondary/20">
      <div class="text-sm font-medium text-secondary mb-4">Total Streaming Out</div>
      <div class="text-4xl font-bold tracking-tight">0.00 <span class="text-xl text-slate-500 font-medium">STX</span></div>
    </div>
  </div>

  <section class="mb-12">
    <div class="flex items-center gap-2 mb-6">
      <h3 class="text-xl font-bold">Incoming Streams</h3>
      <span class="px-2 py-0.5 rounded-full bg-slate-800 text-xs font-medium text-slate-400">{incomingStreams.length}</span>
    </div>

    <div class="rounded-2xl border border-slate-800 bg-slate-900/30 overflow-hidden">
      <table class="w-full text-left border-collapse">
        <thead class="bg-slate-900/50 text-slate-500 text-xs font-bold uppercase tracking-wider">
          <tr>
            <th class="px-6 py-4">Sender</th>
            <th class="px-6 py-4">Rate (STX/s)</th>
            <th class="px-6 py-4">Available</th>
            <th class="px-6 py-4">Progress</th>
            <th class="px-6 py-4 text-right">Action</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-slate-800">
          {#each incomingStreams as stream}
            <tr class="hover:bg-slate-800/30 transition-colors">
              <td class="px-6 py-6 font-mono text-sm">{stream.sender}</td>
              <td class="px-6 py-6 text-sm">{stream.rate}</td>
              <td class="px-6 py-6 text-sm font-bold text-green-400">+{stream.available} STX</td>
              <td class="px-6 py-6">
                <div class="w-full h-1.5 bg-slate-800 rounded-full overflow-hidden">
                  <div class="h-full bg-primary" style="width: {stream.progress}%"></div>
                </div>
              </td>
              <td class="px-6 py-6 text-right">
                <button class="px-4 py-2 bg-slate-800 hover:bg-slate-700 text-white rounded-lg text-sm font-semibold transition-all">
                  Withdraw
                </button>
              </td>
            </tr>
          {/each}
          {#if incomingStreams.length === 0}
            <tr>
              <td colspan="5" class="px-6 py-12 text-center text-slate-500 italic">No incoming streams found.</td>
            </tr>
          {/if}
        </tbody>
      </table>
    </div>
  </section>
</div>
