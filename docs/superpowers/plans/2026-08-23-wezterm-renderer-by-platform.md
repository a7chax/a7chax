# WezTerm Renderer by Platform Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Use WebGPU on macOS and OpenGL on every non-macOS platform.

**Architecture:** Reuse `.wezterm.lua`'s existing `apple-darwin` target-triple check for renderer selection. Keep the WebGPU power preference inside the macOS branch, where it is relevant, and assign OpenGL in the fallback branch.

**Tech Stack:** WezTerm Lua configuration; WezTerm CLI for configuration loading.

## Global Constraints

- The macOS condition is `wezterm.target_triple:find("apple%-darwin")`.
- macOS must use `WebGpu` with `HighPerformance` power preference.
- All non-macOS targets must use `OpenGL` and must not receive a WebGPU power preference.
- Touch only `.wezterm.lua`; no dependencies or unrelated formatting changes.

---

### Task 1: Select the renderer by target platform

**Files:**
- Modify: `.wezterm.lua:49-50`
- Test: configuration load through `wezterm --config-file .wezterm.lua ls-fonts`

**Interfaces:**
- Consumes: `wezterm.target_triple`, supplied by the WezTerm Lua API.
- Produces: `config.front_end` set to `WebGpu` on macOS or `OpenGL` elsewhere.

- [x] **Step 1: Apply the conditional renderer assignment**

Replace the unconditional renderer settings with:

```lua
if wezterm.target_triple:find("apple%-darwin") then
    config.front_end = "WebGpu"
    config.webgpu_power_preference = "HighPerformance"
else
    config.front_end = "OpenGL"
end
```

- [x] **Step 2: Validate the local configuration**

No separate unit test is added because this is a configuration-only change. Run:

```bash
wezterm --config-file .wezterm.lua ls-fonts
```

Expected: exit status 0, demonstrating that WezTerm loaded and evaluated the Lua configuration for the local non-macOS target.

- [x] **Step 3: Review the targeted diff**

Run:

```bash
git diff --check && git diff -- .wezterm.lua
```

Expected: no whitespace errors; only the renderer-selection block changes.

- [x] **Step 4: Commit the implementation**

```bash
git add .wezterm.lua docs/superpowers/plans/2026-08-23-wezterm-renderer-by-platform.md
git commit -m "config: select wezterm renderer by platform"
```
