# homebrew-shpool

Homebrew tap for [shpool](https://github.com/shell-pool/shpool), a lightweight persistent shell session manager for macOS.

> [!WARNING]
> Linux is the primary supported platform. macOS support is functional but some features are still being worked on. See the [platform support notes](https://github.com/shell-pool/shpool/blob/master/HACKING.md) in the main repository for the current state.

## Installation

```
brew tap bumfo/shpool
brew install bumfo/shpool/shpool
```

To have the daemon start automatically at login:

```
brew services start bumfo/shpool/shpool
```

## SSH configuration

The typical use case is connecting to a Mac running `shpool` from a remote machine. Add a block to `~/.ssh/config` on your client:

```
Host = main edit
    Hostname remote.host.example.com

    RemoteCommand /opt/homebrew/bin/shpool attach -f %k
    RequestTTY yes
```

Then `ssh main` or `ssh edit` will create or reattach to a named session. `%k` expands to the host alias used on the command line.

> [!NOTE]
> SSH's `RemoteCommand` runs in a non-login shell that does not source your profile, so `shpool` won't be on `$PATH`. Use the full path to the binary as shown above. Run `which shpool` on the host if it's installed somewhere other than `/opt/homebrew/bin`.

## Configuration

`shpool` can be configured via `~/Library/Application Support/shpool/config.toml` on macOS (or `~/.config/shpool/config.toml` on Linux). See [CONFIG.md](https://github.com/shell-pool/shpool/blob/master/CONFIG.md) in the main repository for the full list of options.

### Custom detach keybinding

The default detach keybinding (`Ctrl-Space`) may conflict with IME switching on macOS. To use double `Ctrl-\` instead, add to your config:

```toml
[[keybinding]]
binding = "Ctrl-\\ Ctrl-\\"
action = "detach"
```

## Shell helpers

Add these to your `~/.zshrc` for convenient session management:

```zsh
# Attach a shpool session running Claude Code in the current directory
# Usage: spc [flags] [claude args...]
#   -n <name>  custom session name (default: current directory path)
#   -d <dir>   custom directory (default: current directory)
spc() {
  local dir=$PWD
  local name
  while [[ $1 == -* ]]; do
    case $1 in
      -n) name="$2"; shift 2 ;;
      -d) dir="$2"; shift 2 ;;
      *) break ;;
    esac
  done
  dir=$(cd "$dir" && pwd)
  name="${name:-$dir}"
  shpool attach "$name" -d "$dir" -c "$(which claude) $*"; tput cnorm
}

# Attach a shpool shell session (default name: current directory path)
spa() { shpool attach "${1:-$PWD}" -d .; tput cnorm }

# List active sessions
spl() { shpool list }
```

> [!NOTE]
> `tput cnorm` restores the terminal cursor after detaching, which is needed because some TUI apps (like Claude Code) hide the cursor.

## More information

- [shpool repository](https://github.com/shell-pool/shpool) — source, full documentation, and Linux installation instructions
- [Wiki](https://github.com/shell-pool/shpool/wiki) — tips, troubleshooting, and advanced usage
