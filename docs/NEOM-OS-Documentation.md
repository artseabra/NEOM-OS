# NEOM OS

**A terminal-based operating layer that transforms your workflow into a voice-first command center.**

---

## What is NEOM OS?

NEOM OS is a custom environment built on Warp Terminal, triggered by Raycast shortcuts, and powered by AI. It's not an app—it's a toolkit. Your personal operating system for productivity.

---

## Origin Story

It started with a simple question: "How do I install SoX?"

What began as a basic audio tool installation evolved into something far more ambitious during a single collaborative session between artsea and Claude (Anthropic). The goal was simple: build a better voice transcription tool than macOS's outdated dictation or expensive services like Whispr.

**The Evolution:**
- **Phase 1**: Basic SoX + OpenAI Whisper transcription
- **Phase 2**: Custom audio feedback (start, stop, thinking, complete sounds)
- **Phase 3**: Notion integration for archival
- **Phase 4**: Discovery of SoX's beautiful waveform in Warp Terminal
- **Phase 5**: The realization—this isn't a tool, it's an operating system

The breakthrough: Warp could be the visual interface, Raycast the launcher, and modular bash scripts the tools. NEOM OS was born.

---

## Architecture

**Warp Terminal** → The interface (visual feedback, waveforms, output)  
**Raycast** → The launcher (keyboard shortcuts trigger Warp commands)  
**Bash Scripts** → The tools (modular, prefixed with `n/`)  
**APIs** → The power (OpenAI, Notion, future integrations)

---

## Tools

### n/home
Startup banner. Your OS greeting.

### n/transcriber v1.0.0
Voice-to-text with dual-format clipboard output. Enhanced UX with animated feedback.

**Features:**
- 10-minute recording limit with audio feedback
- Custom sound effects (start, stop, thinking, complete)
- Dual-format output: Plain Text or Notion AI-ready
- Interactive menu with visual formatting
- NEOM OS branding during processing
- Word count and format confirmation

**v1.0.0 Features:**
- **Neomoticons System**: Animated ASCII faces during processing
- **Enhanced Recording**: SoX waveform + animated singing emoticons
- **Smart Error Handling**: Context-aware error messages with solutions
- **Rich Results Screen**: Content preview, metrics, and visual polish
- **Loading States**: Visual feedback for all processing steps
- **Session Analytics**: Comprehensive recording metrics and summaries

### Future Tools
- n/textart v0.01 (Coming soon) - Text styling and font manipulation
- n/brainstorm
- n/notes
- n/search
- n/export
- n/config

---

## Design

**Colors:**
- Matrix Green `#00FF41` → Active processes
- Purple `#875BE1` → artsea signature & neom-transcriber branding
- Traditional Blue `#0066CC` → Links and folders
- Cyan `#00FFFF` → neom-textart branding
- Black `#0D0D0D` → Background
- Yellow `#FFE81F` → Information

**Tool-Specific Colors:**
Each NEOM OS tool has its own unique color for branding and visual identity during processing.
- **neom-transcriber**: artsea purple `#875BE1`
- **neom-textart**: cyan `#00FFFF`

**Principles:**
- Voice-first
- Visual feedback
- Audio cues
- Minimal friction
- Archival by choice
- Extensible

---

## Tech Stack

Bash • SoX • Warp • Raycast • OpenAI • Notion • macOS

---

## Philosophy

Your computer should adapt to you. NEOM OS combines AI, terminal workflows, and keyboard-driven interfaces to create an environment that feels like an extension of your mind.

This is not a product. This is a toolkit. This is your OS.

---

**Built by artsea & Claude**  
**Version 1.0.1**  
**October 18, 2025**
