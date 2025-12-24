<script lang="ts">
  import './app.css'
  import { connect, disconnect, account, connectionStatus } from './lib/wallet'
  import Landing from './lib/components/Landing.svelte'
  import Dashboard from './lib/components/Dashboard.svelte'
  import Navbar from './lib/components/Navbar.svelte'

  let currentView = 'landing'

  function toggleView(view: string) {
    currentView = view
  }

  $: if ($account.isConnected && currentView === 'landing') {
    currentView = 'dashboard'
  }
</script>

<main class="min-h-screen bg-slate-950 text-slate-50 selection:bg-primary/30">
  <Navbar {currentView} onNavigate={toggleView} />

  {#if currentView === 'landing'}
    <Landing onGetStarted={() => ($account.isConnected ? toggleView('dashboard') : connect())} />
  {:else if currentView === 'dashboard'}
    <Dashboard />
  {/if}

  <footer class="py-8 border-t border-slate-800 text-center text-slate-500 text-sm">
    <p>&copy; 2024 FlowStack. Built for Stacks + WalletConnect Challenge.</p>
  </footer>
</main>
