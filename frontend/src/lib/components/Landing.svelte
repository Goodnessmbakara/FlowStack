<script lang="ts">
  import { motion } from 'framer-motion'
  export let onGetStarted: () => void

  const features = [
    { title: 'DAO Salaries', desc: 'Stream payments to contributors per second.', icon: '💼' },
    { title: 'Freelance Payouts', desc: 'Build trust with real-time payment flows.', icon: '⚡' },
    { title: 'Token Vesting', desc: 'Automate lockups with custom cliff periods.', icon: '🔒' },
    { title: 'Subscriptions', desc: 'Seamless continuous subscription models.', icon: '🔄' }
  ]
</script>

<div class="relative overflow-hidden">
  <!-- Hero Section -->
  <section class="max-w-6xl mx-auto px-6 py-24 text-center relative z-10">
    <div class="inline-block px-4 py-1.5 mb-6 rounded-full bg-primary/10 border border-primary/20 text-primary text-sm font-medium">
      The Future of Continuous Payments on Bitcoin
    </div>
    
    <h1 class="text-6xl md:text-7xl font-extrabold tracking-tight mb-8 bg-gradient-to-b from-white to-slate-400 bg-clip-text text-transparent">
      Stream Your Assets <br /> <span class="text-primary">Every Second</span>
    </h1>
    
    <p class="text-lg text-slate-400 max-w-2xl mx-auto mb-10 leading-relaxed">
      FlowStack enables real-time, continuous payment streaming on Stacks. No more lump sums. Pay your team as they work, with total transparency and security.
    </p>

    <div class="flex flex-col sm:flex-row items-center justify-center gap-4">
      <button 
        on:click={onGetStarted}
        class="px-8 py-4 bg-primary hover:bg-primary-dark text-white rounded-xl font-bold text-lg transition-all shadow-xl shadow-primary/30 hover:-translate-y-1 active:scale-95 flex items-center gap-2"
      >
        Get Started Now
        <span>→</span>
      </button>
      <button class="px-8 py-4 bg-slate-900 border border-slate-800 hover:bg-slate-800 text-slate-200 rounded-xl font-bold text-lg transition-all">
        View Documentation
      </button>
    </div>
  </section>

  <!-- Features Grid -->
  <section class="max-w-6xl mx-auto px-6 py-20">
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
      {#each features as feature}
        <div class="p-8 rounded-2xl bg-slate-900/50 border border-slate-800 hover:border-primary/50 transition-all hover:bg-slate-800/80 group">
          <div class="text-4xl mb-6 group-hover:scale-110 transition-transform">{feature.icon}</div>
          <h3 class="text-xl font-bold mb-3">{feature.title}</h3>
          <p class="text-slate-400 text-sm leading-relaxed">{feature.desc}</p>
        </div>
      {/each}
    </div>
  </section>

  <!-- Visual Ornament -->
  <div class="absolute top-0 left-1/2 -translate-x-1/2 w-full h-full -z-0 opacity-20 pointer-events-none">
    <div class="absolute top-20 left-1/2 -translate-x-1/2 w-[800px] h-[500px] bg-primary/20 blur-[120px] rounded-full"></div>
    <div class="absolute top-40 left-1/4 w-[400px] h-[400px] bg-secondary/10 blur-[100px] rounded-full"></div>
  </div>
</div>
