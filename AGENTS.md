# Workflow

## Check by agent

I'll write all code. Your work here comprise:
- Check my work lightly:
    - Neovim starts without errors: `nvim --headless +qa`
    - New keymaps exist: `:verbose map <key>`
- Review what I wrote against "Review focus" below: is it native/modern for Neovim 0.12+, is there any load-order conflict, can the Lua or the setup be simpler/more correct.
- Don't build test projects or drive the UI. I check the behavior myself after the restart.
- Report only. When I explicitly ask you to implement a fix, edit the relevant source files. Never modify plugins or the lockfile.

### Quick checks (headless, read-only)

1. `nvim --version`: target is 0.12+. If older, say so and stop; everything below assumes 0.12.
2. `nvim --headless +qa 2>&1`: any output (error, warning, deprecation) is a finding.
3. `nvim --headless "+checkhealth vim.pack vim.lsp vim.treesitter vim.deprecated" "+w! /tmp/nvim-health.txt" +qa`, then read the file:
   - `vim.pack`: lockfile out of sync, plugins installed but not loaded (removed from config but never `vim.pack.del`'d).
   - `vim.deprecated`: deprecated APIs used by my config.
4. Resolved LSP config, to check that `lsp/*.lua` and `vim.lsp.config('*')` merge as intended: `nvim --headless "+lua vim.print(vim.lsp.config['lua_ls'])" +qa`.
5. Keymap conflicts: `:verbose map <key>` shows who set it last. Also grep all `keymap.set` calls (`lua/`, `after/`, `lsp/`) for duplicate left-hand sides.
6. Every file in `lua/plugins/` is required from `init.lua` and every `require` there has a file. Files in `lua/plugins/` are NOT auto-sourced; there must be no `plugin/` directory mixed in (double loading).
7. If installed: `stylua --check .`.

Headless startup creates no buffers, so `FileType`, `LspAttach`, `InsertEnter` etc. callbacks don't run. Review those statically; I test them live.

## Review focus

Order findings by severity (see "Report format"). The installed Neovim's `:h` and the plugin's own README/`doc/` at `~/.local/share/nvim/site/pack/core/opt/<name>/` are the source of truth, not memory and not blog posts. If you can't verify something, say "unverified".

### 1. Native-first (0.12+)

Flag anything that works but has a built-in replacement, and name the `:h` tag. Examples:

- Plugin management: only `vim.pack`. No leftover bootstrap code or specs from lazy.nvim / packer / mini.deps.
- LSP: `vim.lsp.config()` / `lsp/<name>.lua` + `vim.lsp.enable()`. Flag any `require('lspconfig').<server>.setup()` (legacy framework). nvim-lspconfig is only a source of default `lsp/*.lua` configs.
- Diagnostics: `vim.diagnostic.config({ signs = { text = {...} } })`, never `sign_define`. `vim.diagnostic.jump()` instead of `goto_next/goto_prev`. `vim.diagnostic.enable(false)` instead of the removed `disable()`. Check `vim.diagnostic.status()` / `vim.lsp.status()` before a custom statusline component.
- Completion: check `'autocomplete'`, `'complete'`, `'completeopt'`, `'pumborder'` and `vim.lsp.completion` (`:h lsp-completion`) before a completion plugin. Native completion reduces the need for plugins, it doesn't always replace them: mention trade-offs, don't insist.
- Built-ins that replace plugins: `gc` commenting, `vim.snippet`, `:Undotree` (`:packadd nvim.undotree`), `:DiffTool` (`:packadd nvim.difftool`), `an`/`in`/`]n`/`[n` tree-sitter selection, LSP `inlay_hint`, `inline_completion`, `vim.net.request()`, `:restart`. `nvim.tohtml` is opt-in now.
- Defaults: don't re-set options that already equal Neovim's defaults (`:h nvim-defaults`).
- Floats and borders: `'winborder'` instead of a `border = ...` on every call.
- Deprecated or renamed APIs: `vim.loop` -> `vim.uv`, `vim.highlight` -> `vim.hl`, `vim.diff` -> `vim.text.diff`, `vim.tbl_islist` -> `vim.islist`, `vim.lsp.get_active_clients` -> `vim.lsp.get_clients`, `nvim_buf_set_option` / `nvim_win_set_option` -> `vim.bo` / `vim.wo` / `nvim_set_option_value`, old-style `vim.validate{}`. Cross-check with `:h deprecated` and the `vim.deprecated` health report.

### 2. Load order and conflicts (`vim.pack`)

- Order in `init.lua`: `vim.g.mapleader` and options -> `config.pack_hooks` -> plugin files, dependencies first (colorscheme early; `plenary` before `telescope`; `lspconfig` before `vim.lsp.enable()`) -> keymaps -> autocmds.
- Hooks. Every `PackChanged` / `PackChangedPre` autocmd must exist BEFORE the first `vim.pack.add()` of the whole config. On a fresh machine all plugins missing from disk but present in `nvim-pack-lock.json` are installed during that first call, so a hook created later never fires for `kind = 'install'`. `kind = 'update'` hooks only need to exist by the time `vim.pack.update()` runs, but keep all of them in `pack_hooks.lua`, required first.
- Hook body: filter on `ev.data.spec.name` and `ev.data.kind`; if `not ev.data.active`, call `vim.cmd.packadd(name)` before using the plugin's commands (e.g. `:TSUpdate`); build with `vim.system({...}, { cwd = ev.data.path })` and check the exit code. Plugins needing a build step (e.g. a `make` for telescope-fzf-native) belong here too.
- Exactly one `vim.pack.add()` per plugin, always before the first `require()` of that plugin and before any plugin that depends on it. Duplicates are harmless but noise.
- Specs: full `https://` URLs; `version` set deliberately (`'main'` for nvim-treesitter if that's the choice, `vim.version.range('2.x')` style for semver); `name` doesn't collide; `data` only if something reads it.
- Keymaps that use a plugin: wrap in a function (`function() require('telescope.builtin').find_files() end`) or use `<cmd>` so the mapping doesn't depend on load order.
- Colorscheme: `vim.cmd.colorscheme()` only after its `vim.pack.add()`. Any `ColorScheme` autocmd (highlight overrides) must be created BEFORE that call, otherwise it misses the first apply. Colorscheme, statusline, dashboard must not be lazy loaded.
- Lazy loading: only moderate and simple (`vim.schedule()` or a plain `once = true` autocmd around `vim.pack.add()` + setup). Flag "load on keymap/command" machinery as over-engineering. A lazy plugin must still end up installed (lockfile).
- Removing a plugin: remove it from the config AND `vim.pack.del()`; never delete its directory by hand. `nvim-pack-lock.json` is tracked in git and never hand-edited.

### 3. LSP

- One file per server in `lsp/<name>.lua` returning a table (`cmd`, `filetypes`, `root_markers`, `settings`); the file name matches the name passed to `vim.lsp.enable()`.
- Shared settings go to `vim.lsp.config('*', {...})`, not copied into each server file.
- `cmd` executable exists (`vim.fn.executable`), `root_markers` are sensible.
- Buffer-local LSP keymaps/features go in an `LspAttach` autocmd, with a capability check (`client:supports_method(...)`) where a feature is optional. Don't remap the 0.12 defaults (`grn`, `gra`, `grr`, `gri`, `grt`, `grx`, `gO`, `K`, insert `<C-S>`) without a reason.
- Features that are not on by default (inlay hints, code lens, linked editing, inline completion) are enabled explicitly if I want them.
- Result of `:checkhealth vim.lsp` is clean.

### 4. Tree-sitter

- The code matches the API of the branch I pinned. The legacy `master` API (`require('nvim-treesitter.configs').setup`) doesn't exist on `main`. Verify against the README at the pinned commit.
- Parser installation: one list in one place, installed asynchronously by the plugin's `install()`. Highlighting must not assume the parser is already there on the first start.
- Highlight / indent / fold are enabled per buffer in a `FileType` autocmd (own augroup): `vim.treesitter.start()`; indent via the plugin's `indentexpr` if used; `foldexpr` as window-local (`v:lua.vim.treesitter.foldexpr()`). Never as global options.
- 0.12: `vim.treesitter.get_parser()` returns `nil` on failure instead of throwing. Any code that uses its result must check for `nil`; `vim.treesitter.start()` is guarded where a parser may be missing.
- No overlap with parsers bundled in Neovim (c, lua, vim, vimdoc, query, markdown) that causes conflicts; check `:checkhealth vim.treesitter`.
- Everything tree-sitter related lives in `lua/plugins/treesitter.lua`; the only exception is the `PackChanged` hook (section 2).

### 5. Options, keymaps, autocmds

- Keymaps: `vim.keymap.set` with `desc` (and `buffer = ...` for local ones). No `nvim_set_keymap`, no `vim.cmd('nnoremap ...')`. Leader set before the first mapping. No duplicate left-hand sides across files, no shadowing of defaults without intent (`:h default-mappings`).
- Autocmds: `nvim_create_augroup(name, { clear = true })` and `group = ...`; `callback` instead of a command string; `once = true` where it's one-shot; the narrowest event that works. No duplicate behavior between `after/ftplugin/*.lua` and `FileType` autocmds.
- `after/ftplugin/*.lua`: buffer/window-local only (`vim.opt_local`, `vim.bo`, `vim.wo`, `buffer = true`). A `vim.o` / global `vim.opt` there leaks into every buffer.
- Options: `vim.o` / `vim.go` / `vim.bo` / `vim.wo` for scalars; `vim.opt` only where list/set helpers (`:append`, `:remove`) are needed. Don't mix styles for no reason.

### 6. Lua quality

- Everything `local`; no accidental globals.
- `vim.cmd.colorscheme('x')` / `vim.cmd.packadd('x')` instead of `vim.cmd('colorscheme x')`; Lua APIs (`vim.uv`, `vim.fs`, `vim.system`, `vim.iter`, `vim.tbl_deep_extend`, `vim.list.unique`) before `vim.fn` / shelling out.
- `pcall` only where failure is legitimate and handled visibly. Never to silence a real error (`pcall(require, ...)` around a plugin I just added hides bugs).
- No `vim.defer_fn` / `vim.schedule` timing hacks without a reason.
- Early returns, no deep nesting, no dead code, no unused locals.
- Don't over-engineer: no custom wrappers or plugin-spec DSLs, no home-made lazy loader, unless the payoff is clear. The config should read like a plain list of calls.
- Shared helpers return a table `M`; plugin files may just run top to bottom.

## Report format

Group findings and order them by severity:

1. **Bug / conflict**: breaks or misbehaves (load order, hook timing, shadowed keymap, removed or renamed API in 0.12).
2. **Outdated / non-native**: works, but a native 0.12 replacement exists. Name the `:h` tag.
3. **Improvement**: simpler, faster, or more correct Lua / setup.

Per finding: `file:line`, what is wrong, why (`:h` tag or README), and a minimal snippet of the fix. If a section is clean, say so in one line. No praise, no retelling my code, no rewritten files, no advice that contradicts the decisions in "File structure".

## File structure

```text
   ~/.config/nvim/
   ├── init.lua
   ├── nvim-pack-lock.json
   │
   ├── lua/
   │   ├── config/
   │   │   ├── options.lua
   │   │   ├── keymaps.lua
   │   │   ├── autocmds.lua
   │   │   └── pack_hooks.lua      # Only if installation/build hooks are needed
   │   │
   │   └── plugins/
   │       ├── lspconfig.lua
   │       ├── treesitter.lua
   │       ├── telescope.lua
   │       ├── plenary.lua
   │       ├── gitsigns.lua
   │       └── colorscheme.lua
   │
   ├── lsp/
   │   ├── lua_ls.lua
   │   ├── pyright.lua
   │   └── ...                     # One file per language server you configure
   │
   └── after/
       └── ftplugin/
           ├── lua.lua
           ├── python.lua
           └── ...                 # Only filetypes needing personal overrides
 ```

1. `init.lua` as a short entry point. This is just a list of enabled plugins, not their configuration. Adding a plugin means creating its file and
 adding a require() here.
2. Tree-sitter configuration together.

`lua/plugins/treesitter.lua` should own:

 - The plugin declaration, including the branch/version I choose.
 - Parser installation configuration.
 - Highlighting and indentation activation.
 - Tree-sitter-specific autocommands.

 Exception: the `PackChanged` hook for tree-sitter lives in `lua/config/pack_hooks.lua`, which is required before any `vim.pack.add()`.
