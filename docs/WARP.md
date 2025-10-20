# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

NEOM OS is a terminal-based operating layer that transforms workflow into a voice-first command center. It's built on Warp Terminal, triggered by Raycast shortcuts, and powered by AI. The architecture consists of modular bash scripts that provide voice transcription, text manipulation, and other productivity tools.

## Architecture

The system follows a modular architecture with clear separation of concerns:

- **Warp Terminal** → The interface (visual feedback, waveforms, output)
- **Raycast** → The launcher (keyboard shortcuts trigger Warp commands)  
- **Bash Scripts** → The tools (modular, prefixed with `neom-`)
- **APIs** → The power (OpenAI, Notion, future integrations)

### Core Components

- `neom-os.sh` - Raycast entry point that launches Warp and executes neom-home
- `neom-home` - Main menu launcher that provides tool selection interface
- `neom-transcriber` - Voice-to-text transcription using OpenAI Whisper
- `neom-emoticons` - Shared emoticon library for consistent visual feedback
- `install.sh` - Complete system setup and dependency management

## Development Commands

### Setup and Installation
```bash
# Install NEOM OS and all dependencies
./install.sh

# Make scripts executable (if needed)
chmod +x neom-home neom-transcriber neom-os.sh neom-welcome install.sh

# Set up environment variables
export NEOM_OS_HOME="$(pwd)"
export PATH="$NEOM_OS_HOME:$PATH"
export OPENAI_API_KEY="your-api-key"
```

### Testing
```bash
# Test bash script syntax for all core scripts
bash -n neom-home && bash -n neom-transcriber && bash -n neom-os.sh && bash -n install.sh

# Run the GitHub Actions test suite locally (requires act or manual execution)
# Tests include: syntax validation, file permissions, directory structure, audio files

# Test individual components
./neom-home          # Test main menu
./neom-transcriber   # Test voice transcription (requires OPENAI_API_KEY)
```

### Development Tools
```bash
# Create recordings directory
mkdir -p recordings

# Launch NEOM OS
./neom-home

# Test Raycast integration (requires Raycast installed)
open -a Raycast
# Then trigger the imported neom-os.sh command
```

## File Structure & Key Patterns

### Script Naming Convention
All NEOM OS tools are prefixed with `neom-` and follow consistent patterns:
- `neom-home` - Main launcher
- `neom-transcriber` - Voice transcription tool  
- `neom-textart` - Text styling (coming soon)
- `neom-emoticons` - Shared emoticon library

### Color System
Scripts use consistent ANSI color coding:
- Matrix Green `#00FF41` → Active processes
- Purple `#875BE1` → artsea signature & neom-transcriber branding
- Blue `#0066CC` → Links and folders
- Cyan `#00FFFF` → neom-textart branding  
- Yellow `#FFE81F` → Information
- Gray → Footer/secondary information

### Directory Structure
- `/docs/` - Documentation and version management
- `/sounds/` - Audio feedback files (start, stop, thinking, complete)
- `/recordings/` - Temporary audio recordings (auto-created)
- `/backups/` - Script backups and previous versions
- `/updates/` - Version update documentation
- `/.github/` - GitHub Actions workflows and issue templates

## Dependencies & Requirements

### System Requirements
- macOS 10.15+
- Warp Terminal
- Raycast
- Homebrew

### Package Dependencies
- SoX (audio processing): `brew install sox`
- jq (JSON processing): `brew install jq` 
- OpenAI API key for transcription services

### Environment Variables
- `NEOM_OS_HOME` - Path to NEOM OS installation directory
- `OPENAI_API_KEY` - Required for neom-transcriber functionality
- `PATH` - Must include NEOM_OS_HOME for global script access

## Integration Points

### Raycast Integration
- Import `neom-os.sh` as a Raycast script command
- Configure keyboard shortcut for instant access
- Script uses AppleScript to activate Warp and execute commands

### Warp Terminal Integration  
- Scripts designed specifically for Warp's terminal interface
- Utilizes Warp's visual feedback capabilities (waveforms, colors)
- All output formatted for terminal display with proper ANSI codes

### OpenAI API Integration
- neom-transcriber uses Whisper API for voice-to-text
- Handles API errors gracefully with user-friendly messages
- Supports audio files up to 10 minutes in length

## Development Guidelines

### Error Handling
- All scripts include comprehensive error checking
- API failures provide actionable error messages
- File operations validate success before proceeding
- Missing dependencies trigger helpful installation guidance

### User Experience Patterns
- Consistent visual branding across all tools
- Audio feedback for state changes (when audio files present)
- Clear loading states during processing
- Clipboard integration for seamless workflow

### Modular Design
- Each tool is self-contained and executable independently
- Shared functionality isolated in neom-emoticons library
- Configuration centralized in environment variables
- Clean separation between UI, logic, and external API calls

## Testing Strategy

The project uses GitHub Actions for automated testing with the following validations:
- Bash syntax checking for all scripts
- File permission verification (executable status)
- Directory structure validation
- Required file existence checks (README, LICENSE, audio files)
- Dependency installation testing on macOS

When contributing, ensure all scripts pass syntax validation and maintain executable permissions.