import { createAppKit } from '@reown/appkit'
import { writable } from 'svelte/store'
import { StacksMainnet, StacksTestnet } from '@stacks/network'

// Get project ID from environment
const projectId = import.meta.env.VITE_REOWN_PROJECT_ID || '103565fcf72322cd4ce53d52c2865768' // Default or placeholder

export const account = writable<{ address: string | null; isConnected: boolean }>({
  address: null,
  isConnected: false,
})

export const connectionStatus = writable<'connected' | 'disconnected' | 'connecting'>('disconnected')

const network = import.meta.env.VITE_STACKS_NETWORK === 'mainnet' ? new StacksMainnet() : new StacksTestnet()

// Initialize AppKit
export const modal = createAppKit({
  adapters: [], // Stacks adapter is usually handled by @stacks/connect, but we use AppKit for discovery
  networks: [], 
  projectId,
  features: {
    analytics: true,
  },
  themeMode: 'dark',
})

// Wallet functions
export async function connect() {
  connectionStatus.set('connecting')
  try {
    await modal.open()
  } catch (err) {
    console.error('Failed to open modal:', err)
    connectionStatus.set('disconnected')
  }
}

export function disconnect() {
  modal.disconnect()
  account.set({ address: null, isConnected: false })
  connectionStatus.set('disconnected')
}

// Subscribe to modal state if needed
modal.subscribeEvents(event => {
  if (event.data.event === 'MODAL_CLOSE') {
    // Check connection after close
  }
})
