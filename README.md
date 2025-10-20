# NEOM OS

**A terminal-based operating layer that transforms your workflow into a voice-first command center.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![macOS](https://img.shields.io/badge/macOS-10.15+-blue.svg)](https://www.apple.com/macos/)
[![Bash](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)

---

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/NEOM-OS.git
cd NEOM-OS

# Run the installer
chmod +x install.sh
./install.sh
```

## 🎯 What is NEOM OS?

NEOM OS is a custom environment built on Warp Terminal, triggered by Raycast shortcuts, and powered by AI. It's not an app—it's a toolkit. Your personal operating system for productivity.

### Architecture

- **Warp Terminal** → The interface (visual feedback, waveforms, output)
- **Raycast** → The launcher (keyboard shortcuts trigger Warp commands)
- **Bash Scripts** → The tools (modular, prefixed with `neom-`)
- **APIs** → The power (OpenAI, Notion, future integrations)

## 🛠️ Tools

### neom-transcriber v1.0.0
Voice-to-text with dual-format clipboard output. Enhanced UX with animated feedback.

**Features:**
- 10-minute recording limit with audio feedback
- Custom sound effects (start, stop, thinking, complete)
- Dual-format output: Plain Text or Notion AI-ready
- Interactive menu with visual formatting
- NEOM OS branding during processing
- Word count and format confirmation

### neom-textart v0.01 (Coming Soon)
Text styling and font manipulation tool.

## 🎨 Design

**Colors:**
- Matrix Green `#00FF41` → Active processes
- Purple `#875BE1` → artsea signature & neom-transcriber branding
- Traditional Blue `#0066CC` → Links and folders
- Cyan `#00FFFF` → neom-textart branding
- Black `#0D0D0D` → Background
- Yellow `#FFE81F` → Information

## 📋 Requirements

- macOS 10.15+
- [Warp Terminal](https://www.warp.dev/)
- [Raycast](https://raycast.com/)
- [SoX](http://sox.sourceforge.net/) for audio processing
- OpenAI API key for transcription

## 🔧 Installation

1. **Install Dependencies:**
   ```bash
   # Install SoX
   brew install sox
   
   # Install jq for JSON processing
   brew install jq
   ```

2. **Set up Environment:**
   ```bash
   # Add to your ~/.zshrc or ~/.bash_profile
   export OPENAI_API_KEY="your-api-key-here"
   ```

3. **Configure Raycast:**
   - Import the `neom-os.sh` script as a Raycast command
   - Set up your preferred keyboard shortcut

## 📖 Documentation

- [Full Documentation](docs/NEOM-OS-Documentation.md)
- [Changelog](docs/CHANGELOG.md)
- [Version Management](docs/NEOM-OS-Version-Management.md)
- [Neomoticons](docs/NEOMOTICONS.md)

## 🏗️ Tech Stack

Bash • SoX • Warp • Raycast • OpenAI • Notion • macOS

## 🎭 Philosophy

Your computer should adapt to you. NEOM OS combines AI, terminal workflows, and keyboard-driven interfaces to create an environment that feels like an extension of your mind.

This is not a product. This is a toolkit. This is your OS.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Art Seabra** - [@artsea](https://sn.ifth.is/art)

Built collaboratively by **artsea** & **Claude (Anthropic)**

---

**Version 2.2** • **October 18, 2025**
