/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{html,js,svelte,ts}'],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#3b82f6',
          dark: '#2563eb',
        },
        secondary: '#a855f7',
        success: '#16a34a',
        'bg-dark': '#0f172a',
        'bg-card': '#1e293b',
      }
    },
  },
  plugins: [],
}
