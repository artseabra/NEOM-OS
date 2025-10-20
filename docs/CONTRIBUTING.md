# Contributing to NEOM OS

Thank you for your interest in contributing to NEOM OS! This document provides guidelines and information for contributors.

## 🚀 Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/yourusername/NEOM-OS.git
   cd NEOM-OS
   ```
3. **Set up the development environment**:
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

## 🛠️ Development Guidelines

### Code Style
- Use clear, descriptive variable names
- Add comments for complex logic
- Follow bash best practices
- Keep functions focused and modular

### Script Structure
- All NEOM OS tools should be prefixed with `neom-`
- Include version information at the top
- Use consistent color coding (see design guidelines)
- Include error handling and user feedback

### Testing
- Test your changes on macOS
- Verify all dependencies are properly handled
- Test error conditions and edge cases
- Ensure scripts are executable

## 🎨 Design Guidelines

### Colors
- **Matrix Green** `#00FF41` → Active processes
- **Purple** `#875BE1` → artsea signature & neom-transcriber branding
- **Blue** `#0066CC` → Links and folders
- **Cyan** `#00FFFF` → neom-textart branding
- **Yellow** `#FFE81F` → Information

### User Experience
- Provide clear feedback for all actions
- Use audio cues when appropriate
- Include loading states for long operations
- Make error messages helpful and actionable

## 📝 Pull Request Process

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**:
   - Write clear, focused commits
   - Test thoroughly
   - Update documentation if needed

3. **Submit a pull request**:
   - Provide a clear description of changes
   - Reference any related issues
   - Include screenshots for UI changes

## 🐛 Bug Reports

When reporting bugs, please include:
- macOS version
- Warp Terminal version
- Raycast version
- SoX version
- Steps to reproduce
- Expected vs actual behavior
- Error messages or logs

## 💡 Feature Requests

When suggesting features:
- Describe the problem you're trying to solve
- Explain how the feature would work
- Consider the impact on existing functionality
- Think about implementation complexity

## 📋 Issue Labels

- `bug` - Something isn't working
- `enhancement` - New feature or request
- `documentation` - Improvements to documentation
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention is needed

## 🤝 Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help others learn and grow
- Follow the golden rule

## 📞 Getting Help

- Check existing issues and discussions
- Ask questions in GitHub Discussions
- Review the documentation in `/docs`
- Look at existing code for examples

## 🎯 Project Goals

NEOM OS aims to be:
- **Voice-first** - Optimized for voice interaction
- **Visual** - Rich terminal feedback
- **Modular** - Easy to extend and customize
- **Reliable** - Robust error handling
- **Delightful** - Fun to use

Thank you for contributing to NEOM OS! 🚀
