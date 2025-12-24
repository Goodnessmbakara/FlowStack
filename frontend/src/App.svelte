<script lang="ts">
  import './app.css'
  import { connect, disconnect, account, connectionStatus } from './lib/wallet'
  import Landing from './lib/components/Landing.svelte'
  import Dashboard from './lib/components/Dashboard.svelte'
  import CreateStream from './lib/components/CreateStream.svelte'
  import StreamDetails from './lib/components/StreamDetails.svelte'
  import Navbar from './lib/components/Navbar.svelte'

  let currentView = 'landing'
  let selectedStreamId = null

  function navigate(view: string, id: string = null) {
    currentView = view
    selectedStreamId = id
  }

  $: if ($account.isConnected && currentView === 'landing') {
    currentView = 'dashboard'
  }
</script>

<main class="min-h-screen bg-slate-950 text-slate-50 selection:bg-primary/30">
  <Navbar {currentView} onNavigate={navigate} />

  {#if currentView === 'landing'}
    <Landing onGetStarted={() => ($account.isConnected ? navigate('dashboard') : connect())} />
  {:else if currentView === 'dashboard'}
    <Dashboard onCreateClick={() => navigate('create')} onStreamClick={(id) => navigate('stream', id)} />
  {:else if currentView === 'create'}
    <CreateStream onCreated={() => navigate('dashboard')} />
  {:else if currentView === 'stream'}
    <StreamDetails onBack={() => navigate('dashboard')} />
  {/if}

  <footer class="py-8 border-t border-slate-800 text-center text-slate-500 text-sm">
    <p>&copy; 2024 FlowStack. Built for Stacks + WalletConnect Challenge.</p>
  </footer>
</main>
