# HTML → Instagram carousel renderer

An Instagram carousel (7 slides, 1080×1350) for my PC repair business, designed as **HTML/CSS** and
rendered to PNG with **headless Chrome** — so layout, typography and copy are code that an AI
agent can write and iterate on, and the export is pixel-exact.

![slide 1](out/abdalla-tech-preventiva-1.png)

## How it works

1. `slides.html` — all 7 slides in one page; `?s=N` shows slide N alone at 1080×1350.
2. `render.ps1` — opens each slide in headless Chrome at 2× device scale (2160×2700), then
   downsamples to 1080×1350 with high-quality interpolation (better antialiasing than rendering at 1×).
   Final files go to `out/`.
3. `build-preview.mjs` — inlines the logo and slide previews as data URIs into a single
   self-contained `preview.html` to review the whole carousel before posting.
4. `legenda.md` — the post caption.

```powershell
./render.ps1                 # set CHROME_PATH if Chrome is not in the default location
node build-preview.mjs
```

**Stack:** HTML/CSS · headless Chrome · PowerShell (System.Drawing) · Node.js · Claude Code
