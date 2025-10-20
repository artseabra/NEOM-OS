# NEOM OS Version Management System

## Overview
This document defines the version management system for NEOM OS development, ensuring clean progression from working baselines through incremental improvements.

## Version Types

### Major Versions (v1, v2, v3, v4...)
Use for **architectural changes** or **complete rewrites**:

- **v1.0.0**: Current stable baseline (49 lines)
- **v0.2.0-beta**: Beta version with advanced features (474 lines) - archived for future reference
- **v2.0.0**: Future major rewrite with new architecture
- **v3.0.0**: Future major rewrite with different approach

**When to create a new major version:**
- Complete script rewrite from scratch
- Fundamental change in approach (e.g., different recording method)
- Breaking changes that make previous versions incompatible
- Major feature additions that change the core workflow

### Minor Versions (v1.1.0, v1.2.0, v2.1.0, v2.2.0...)
Use for **feature additions** or **significant improvements**:

- **v1.1.0**: Add back sound effects (carefully)
- **v1.2.0**: Add back simple animations (without line conflicts)
- **v1.3.0**: Add back formatting options (one at a time)
- **v1.4.0**: Add back session summaries
- **v1.5.0**: Add back error handling screens

**When to create a new minor version:**
- Adding a new feature from v2 reference
- Significant UI improvements
- New functionality that enhances the core workflow
- Performance improvements
- Bug fixes that add new capabilities

### Patch Versions (v1.1.1, v1.1.2, v1.2.1...)
Use for **bug fixes** and **small improvements**:

- **v1.1.1**: Fix sound timing issues
- **v1.1.2**: Fix animation display bugs
- **v1.2.1**: Fix formatting edge cases
- **v1.2.2**: Improve error messages

### Beta Versions (v0.x.x-beta)
Use for **experimental features** and **advanced functionality**:

- **v0.2.0-beta**: Complex version with full feature set (474 lines) - archived for reference

**When to create a new patch version:**
- Bug fixes that don't add new features
- Small UI tweaks
- Performance optimizations
- Documentation updates
- Code cleanup

## Development Workflow

### For neom-transcriber specifically:

1. **v1.0.0** (current): Barebones baseline - working, simple, no conflicts
2. **v1.1.0**: Add back sound effects (test thoroughly)
3. **v1.2.0**: Add back simple animations (ensure no line conflicts)
4. **v1.3.0**: Add back one formatting option (test each)
5. **v1.4.0**: Add back session summaries
6. **v1.5.0**: Add back error handling screens
7. **v2.0.0**: When we've successfully re-implemented all v0.2.0-beta features without the problems

### Backup Strategy:
```
backups/
├── neom-transcriber-v1.0.0.sh (current stable baseline)
├── neom-transcriber-v1.1.0.sh (with sounds)
├── neom-transcriber-v1.2.0.sh (with animations)
├── neom-transcriber-v1.3.0.sh (with formatting)
├── neom-transcriber-complex-v0.2.0-beta.sh (complex beta version)
└── neom-transcriber-v2.0.0.sh (future major rewrite)
```

### Archived Implementations
```
backups/
├── whisper-transcribe-raycast.sh (Raycast/Notion implementation)
```

## Naming Convention

- **Scripts**: `neom-transcriber-v1.2.0.sh`
- **Folders**: `backups/`, `docs/`, `updates/`
- **Documentation**: `docs/neom-transcriber-v1.2.0-changelog.md`
- **Update files**: `updates/update-v1.2.0-YYYY-MM-DD.md`

## Decision Matrix

| Change Type | Version Bump | Example |
|-------------|--------------|---------|
| Bug fix only | Patch (v1.1.1) | Fix sound timing |
| New feature | Minor (v1.2.0) | Add animations |
| Complete rewrite | Major (v2.0.0) | New architecture |
| Breaking change | Major (v2.0.0) | Incompatible API |
| Performance improvement | Minor (v1.2.0) | Faster processing |
| UI enhancement | Minor (v1.2.0) | Better display |
| Code cleanup | Patch (v1.1.1) | Refactor functions |
| Experimental features | Beta (v0.x.x-beta) | Advanced functionality |

## Quality Gates

- **v1.x.x**: Must work without line conflicts
- **v1.x.x**: Must not get stuck after recording
- **v1.x.x**: Must maintain simple user experience
- **v0.x.x-beta**: Can be complex but experimental
- **v2.0.0+**: Can be complex but must be stable

## Summary

This system provides clear progression from the working v1.0.0 baseline, through incremental improvements (v1.x.x), to a stable v2.0.0 that has all the features but without the problems. The v0.2.0-beta version serves as a reference for advanced features to be carefully re-implemented in the v1.x.x series.

---

*Created: October 19, 2025*
*Last Updated: October 19, 2025*
