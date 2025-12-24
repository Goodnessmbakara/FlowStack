<script lang="ts">
  import { connect, disconnect, account } from '../wallet'
  
  export let currentView: string
  export let onNavigate: (view: string) => void
</script>

<nav class="flex items-center justify-between px-6 py-4 border-b border-slate-800 bg-slate-900/50 backdrop-blur-md sticky top-0 z-50">
  <div class="flex items-center gap-2 cursor-pointer" on:click={() => onNavigate('landing')}>
    <div class="w-8 h-8 rounded-lg bg-gradient-to-br from-primary to-secondary flex items-center justify-center font-bold text-white shadow-lg shadow-primary/20">
      F
    </div>
    <span class="text-xl font-bold tracking-tight">FlowStack</span>
  </div>

  <div class="flex items-center gap-6">
    {#if $account.isConnected}
      <button 
        class="text-sm font-medium hover:text-primary transition-colors"
        class:text-primary={currentView === 'dashboard'}
        on:click={() => onNavigate('dashboard')}
      >
        Dashboard
      </button>
      
      <div class="flex items-center gap-3 pl-6 border-l border-slate-800">
        <span class="text-xs font-mono text-slate-400 bg-slate-800 px-2 py-1 rounded">
          {$account.address?.slice(0, 5)}...{$account.address?.slice(-5)}
        </span>
        <button 
          on:click={disconnect}
          class="text-xs text-red-400 hover:text-red-300 transition-colors"
        >
          Disconnect
        </button>
      </div>
    {:else}
      <button 
        on:click={connect}
        class="bg-primary hover:bg-primary-dark text-white px-5 py-2 rounded-full text-sm font-semibold transition-all shadow-lg shadow-primary/25 active:scale-95"
      >
        Connect Wallet
      </button>
    {/if}
  </div>
</nav>
