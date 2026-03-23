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

## More information

- [shpool repository](https://github.com/shell-pool/shpool) — source, full documentation, and Linux installation instructions
- [Wiki](https://github.com/shell-pool/shpool/wiki) — tips, troubleshooting, and advanced usage
