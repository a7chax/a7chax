# WezTerm renderer selection by platform

## Goal

Use WebGPU on macOS and OpenGL on every non-macOS platform.

## Design

The existing `wezterm.target_triple:find("apple%-darwin")` check will own renderer selection:

- macOS (`apple-darwin`): set `config.front_end` to `WebGpu` and retain the
  `HighPerformance` WebGPU power preference.
- all other targets: set `config.front_end` to `OpenGl` and omit
  `webgpu_power_preference`, since it applies only to WebGPU.

This keeps all platform detection in the configuration's existing target-triple
convention and applies a deterministic fallback for Linux, Windows, and any
other supported non-macOS platform.

## Verification

Run WezTerm's Lua configuration validation for the local target. Review the
conditional assignment to confirm macOS has WebGPU settings and the fallback
has OpenGL only.
