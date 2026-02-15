---
name: outpost-design
description: Design system and UI guidelines for the Outpost chat application. Use when creating or modifying any UI components, views, layouts, or styles in the Outpost codebase. Enforces a retro, techy, pixelated aesthetic with chunky borders and terminal-inspired visuals.
---

# Outpost Design System

Retro-techy aesthetic inspired by early computing, pixel art, and terminal interfaces. Think chunky borders, monospace vibes, CRT glow effects, and that satisfying computer feel.

## Color Palette

### Core Colors (CSS Variables)

```css
:root {
  /* Background layers */
  --bg-primary: #0a0a0a;      /* Near black - main background */
  --bg-secondary: #141414;    /* Slightly lighter - cards, panels */
  --bg-tertiary: #1e1e1e;     /* Input fields, hover states */
  
  /* Foreground */
  --fg-primary: #e0e0e0;      /* Main text */
  --fg-secondary: #888888;    /* Muted text, labels */
  --fg-tertiary: #555555;     /* Disabled, hints */
  
  /* Accent - Phosphor green (CRT inspired) */
  --accent: #00ff88;          /* Primary actions, links */
  --accent-dim: #00cc6a;      /* Hover states */
  --accent-glow: rgba(0, 255, 136, 0.15); /* Glow effects */
  
  /* Secondary accent - Amber (warning/warm) */
  --amber: #ffaa00;
  --amber-dim: #cc8800;
  
  /* Status colors */
  --success: #00ff88;         /* Same as accent */
  --warning: #ffaa00;         /* Amber */
  --error: #ff4444;           /* Red */
  --info: #4488ff;            /* Blue */
  
  /* Borders */
  --border: #333333;          /* Standard borders */
  --border-focus: #00ff88;    /* Focus states */
}
```

### Tailwind Usage

Map these to Tailwind where possible:
- `bg-neutral-950` → --bg-primary
- `bg-neutral-900` → --bg-secondary
- `bg-neutral-800` → --bg-tertiary
- `text-neutral-200` → --fg-primary
- `text-neutral-500` → --fg-secondary
- `border-neutral-700` → --border

For accent colors, use custom classes or inline styles until we set up Tailwind config.

## Typography

### Font Stack

```css
/* Primary - Monospace for that terminal feel */
--font-mono: 'JetBrains Mono', 'Fira Code', 'SF Mono', 'Consolas', monospace;

/* UI elements can use system fonts for readability */
--font-sans: 'Inter', system-ui, -apple-system, sans-serif;
```

### Scale

- **Headings**: Use monospace, uppercase optional for emphasis
- **Body**: 14-16px base, generous line-height (1.6)
- **Code/Data**: Always monospace
- **Labels**: Small caps or uppercase with letter-spacing

### Examples

```html
<!-- Page title -->
<h1 class="font-mono text-2xl uppercase tracking-wider text-neutral-200">
  Outpost
</h1>

<!-- Section header -->
<h2 class="font-mono text-lg text-neutral-300">
  Conversations
</h2>

<!-- Body text -->
<p class="text-sm text-neutral-400 leading-relaxed">
  Welcome to your chat.
</p>
```

## Components

### Buttons

Chunky, obvious, satisfying to click.

```html
<!-- Primary button -->
<button class="
  px-4 py-2
  bg-[#00ff88] hover:bg-[#00cc6a]
  text-black font-mono font-medium
  border-2 border-black
  shadow-[4px_4px_0_0_#000]
  hover:shadow-[2px_2px_0_0_#000]
  hover:translate-x-[2px] hover:translate-y-[2px]
  transition-all
">
  Create Account
</button>

<!-- Secondary button -->
<button class="
  px-4 py-2
  bg-neutral-800 hover:bg-neutral-700
  text-neutral-200 font-mono
  border-2 border-neutral-600
  shadow-[4px_4px_0_0_#333]
  hover:shadow-[2px_2px_0_0_#333]
  hover:translate-x-[2px] hover:translate-y-[2px]
  transition-all
">
  Cancel
</button>

<!-- Danger button -->
<button class="
  px-4 py-2
  bg-red-600 hover:bg-red-500
  text-white font-mono font-medium
  border-2 border-red-900
  shadow-[4px_4px_0_0_#7f1d1d]
  hover:shadow-[2px_2px_0_0_#7f1d1d]
  hover:translate-x-[2px] hover:translate-y-[2px]
  transition-all
">
  Delete
</button>
```

### Form Inputs

```html
<!-- Text input -->
<input type="text" class="
  w-full px-3 py-2
  bg-neutral-900
  text-neutral-200 font-mono
  border-2 border-neutral-700
  focus:border-[#00ff88] focus:outline-none
  focus:shadow-[0_0_10px_rgba(0,255,136,0.3)]
  placeholder:text-neutral-600
">

<!-- With label -->
<label class="block">
  <span class="text-sm font-mono text-neutral-400 uppercase tracking-wide">
    Email Address
  </span>
  <input type="email" class="mt-1 w-full px-3 py-2 ...">
</label>
```

### Cards / Panels

```html
<div class="
  bg-neutral-900
  border-2 border-neutral-700
  p-4
  shadow-[4px_4px_0_0_#1a1a1a]
">
  <!-- Card content -->
</div>
```

### Messages (Chat)

```html
<!-- User message -->
<div class="flex gap-3">
  <div class="w-8 h-8 bg-neutral-700 border border-neutral-600 flex-shrink-0"></div>
  <div>
    <div class="text-sm font-mono text-neutral-400">username</div>
    <div class="text-neutral-200 mt-1">Message content here...</div>
  </div>
</div>

<!-- Digital member message -->
<div class="flex gap-3">
  <div class="w-8 h-8 bg-[#00ff88]/20 border border-[#00ff88]/50 flex-shrink-0"></div>
  <div>
    <div class="text-sm font-mono text-[#00ff88]">agent-name</div>
    <div class="text-neutral-200 mt-1">Agent response here...</div>
  </div>
</div>
```

## Layout

### Sidebar + Main Pattern

```html
<div class="flex h-screen bg-neutral-950">
  <!-- Sidebar -->
  <aside class="w-64 bg-neutral-900 border-r-2 border-neutral-800 flex flex-col">
    <!-- Logo/header -->
    <div class="p-4 border-b-2 border-neutral-800">
      <h1 class="font-mono text-lg text-[#00ff88]">OUTPOST</h1>
    </div>
    <!-- Navigation -->
    <nav class="flex-1 p-2">
      <!-- Nav items -->
    </nav>
  </aside>
  
  <!-- Main content -->
  <main class="flex-1 flex flex-col">
    <!-- Content -->
  </main>
</div>
```

### Nav Items

```html
<a href="#" class="
  flex items-center gap-2 px-3 py-2
  text-neutral-400 hover:text-neutral-200
  hover:bg-neutral-800
  font-mono text-sm
  border-l-2 border-transparent
  hover:border-[#00ff88]
">
  # general
</a>
```

## Effects

### Glow (for focus states, active elements)

```css
.glow-accent {
  box-shadow: 0 0 10px rgba(0, 255, 136, 0.3),
              0 0 20px rgba(0, 255, 136, 0.1);
}
```

### Scanlines (optional, subtle)

```css
.scanlines::after {
  content: '';
  position: absolute;
  inset: 0;
  background: repeating-linear-gradient(
    0deg,
    transparent,
    transparent 2px,
    rgba(0, 0, 0, 0.1) 2px,
    rgba(0, 0, 0, 0.1) 4px
  );
  pointer-events: none;
}
```

### Pixelated borders (for special elements)

Use `image-rendering: pixelated` on decorative elements or consider SVG pixel art for icons.

## Iconography

Prefer simple, geometric, pixel-art style icons:
- Line icons with 2px stroke
- Simple geometric shapes
- Monochrome (use current color)

Consider: Phosphor Icons (has a "bold" weight that works), or custom pixel art SVGs.

## Animation

Keep it snappy and mechanical:
- Short durations (100-200ms)
- Ease-out or linear timing
- Avoid bouncy/elastic effects
- Step-based animations for extra retro feel

```css
.transition-retro {
  transition: all 100ms steps(4, end);
}
```

## Anti-patterns

Avoid these - they break the aesthetic:
- Rounded corners (use sharp corners or small 2px radius max)
- Gradients (use flat colors)
- Soft shadows (use hard offset shadows)
- Script/decorative fonts
- Pastel colors
- Smooth animations with bounce
