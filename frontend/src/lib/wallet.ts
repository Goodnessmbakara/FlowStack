import { createAppKit } from '@reown/appkit'
import { writable } from 'svelte/store'
import { StacksMainnet, StacksTestnet } from '@stacks/network'

// Get project ID from environment
const projectId = import.meta.env.VITE_REOWN_PROJECT_ID || '103565fcf72322cd4ce53d52c2865768'

export const account = writable<{ address: string | null; isConnected: boolean }>({
  address: null,
  isConnected: false,
})

export const connectionStatus = writable<'connected' | 'disconnected' | 'connecting'>('disconnected')

export const network = import.meta.env.VITE_STACKS_NETWORK === 'mainnet' ? new StacksMainnet() : new StacksTestnet()

const networks = [network]

// Initialize AppKit
export const modal = createAppKit({
  adapters: [], 
  networks, 
  projectId,
  features: {
    analytics: true,
  },
  themeMode: 'dark',
})

// Sync state
modal.subscribeState(state => {
  account.set({
    address: state.address || null,
    isConnected: !!state.address
  })
  connectionStatus.set(state.address ? 'connected' : 'disconnected')
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
}
