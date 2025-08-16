# hardened-configs

## Overview

**hardened-configs** configuration files and scripts used in Prism OS, applicable to almost any Linux distribution to enhance security, improve privacy and reduce attack surface.

## Inofrmation

- **Scripts**: Located in `bin/`. These are wrapper scripts around programs like `curl` and `wget` to protect against HTTPS downgrade attacks, ensures TLS 1.3 is always used, and changes the user agent to that of a real browser. Additionally, there's also a `scurl-tor` script (curl over Tor) for making requests to onion services.  
  There's also a `setup` script which disables and masks various services like geoclue, cups and avahi, renames the hostname to `localhost` and the username to `user` to minimize information leakage. The script also deletes binaries like `sudo`, `su`, `ksu`, and `pkexec`, and removes the SETUID and SETGID bits from binaries, granting necessary binaries capabilities instead. Use `run0` to escalate privileges to root instead. A rule in `etc/polkit-1/rules.d/` enables the persist feature, though it may not function until an update containing this [PR](https://github.com/polkit-org/polkit/pull/533) is rolled out.

- **Configurations**: Located in `etc/`. These configurations improve the security of your machine and reduce its attack surface. Key changes include:
  - Replace the machine ID with a generic one (used by WHONIX).
  - Blacklist several kernel modules to reduce attack surface.
  - Various sysctl values for system hardening, note that the provided sysctl values for system hardening may duplicate existing settings on your system, especially if you are using the linux-hardened kernel. I have included all values in the configuration file to ensure compatibility with most distributions. This should not cause any problems. (see: `etc/sysctl.d/60-hardening.conf`)
  - The default umask Is `0077`.
  - Enables per-network MAC randomization and flushes the DHCP client state before connecting to a network so that the network can not identify that you're connecting with the same device, a unique DUID (DHCP unique identifier) per connection, and a script to disable hostname broadcasting (note: this only works with MAC randomization enabled and from the second connection).
  - The network-provided DNS server Is used to resolve domain names by default. Using the network-provided DNS servers is the best way to blend in with other users. In some broken or unusual network environments, the network could fail to provide DNS servers or do it on purpose to fingerprint the clients seeing this I have provided **commonly** used DNS servers with good privacy policy (cloudflare and quad9, both support DNSSEC and DoT) as fallback. (see: `etc/resolved.conf`).
  - Restrict the number of processes that can be forked to mitigate fork bombs (see: `etc/security/limits.conf`).
  - Add a limit to restrict consecutive failed authentication attempts, with a default value of 30 then lockout for 24 hours. (see: `etc/security/faillock.conf`).
  - Allow only users in the 'wheel' or 'adm' group to escalate privileges to root; on some distributions, the 'wheel' group is 'root' (edit `etc/security/access.conf` as needed).
  - Enforce strong passwords using the pwquality PAM module (see: `etc/pam.d/passwd`).
  - Increase the password hashing rounds to 8, and use YESCRYPT-based algorithm for encryptying passwords; Arch Linux uses YESCRYPT-based algorithm for encrypting passwords by default. (see: `etc/login.defs`).
  - Use NTS servers instead of unencrypted NTP servers (see: `etc/chrony.conf`).
  - Kernel arguments (located in `etc/KARGS`) disable SMT, enable mitigations for spectre, provide mitigations against DMA attacks, reduce information leakage, etc.
  - Hardened malloc is preloaded by specifying its shared object in the `/etc/ld.so.preload` file, which is set with permission `600`. This ensures that only root can read or modify the file, so all root processes (including PID 1) always use hardened malloc. User processes can still unset the variable as needed, providing flexibility for user applications while maintaining strict enforcement for system and privileged processes. This approach is derived from secureblue.
  - Additionally there's a systemd service (`etc/systemd/system/autowipe.service`) which securely deletes data which may still lie In your memory before shutting down, rebooting or halt. It uses the smem tool from the [secure-delete](https://github.com/prismos-org/secure-delete) toolkit. Currently the total insecure mode Is used meaning only one pass with 0x00 Is written to the memory, any other option Is way too slow to be feasable. I'll replace this If I find a better option. (Note: This Is only really needed In machines which do not use the hardened kernel and hardened malloc. See: https://grapheneos.org/features#exploit-mitigations)

## Using These Configurations and Scripts

### Arch Linux

#### Install Using Prism OS Repository

1. Add the repository to `/etc/pacman.conf`:
    ```sh
    [prismos]
    Server = https://prismos.codeberg.page/prismos-repo/x86_64
    ```
2. Run:
    ```sh
    pacman -Syu
    ```
3. Install the 'prismos-keyring' package:
    ```sh
    pacman -S prismos-keyring
    ```
4. Finally install the 'hardened-configs' package:
    ```sh
    pacman -S hardened-configs
    ```
    The script automatically backs up your current GRUB config to `/etc/grub.bak`, but just to make sure make a backup of it yourself. You may need to remove conflicting files for a successful installation. The package also installs [pusbctl](https://github.com/prismos-org/pusbctl) a tool for protecting against rogue USB devices like a rubber ducky, AppArmor, chrony, and [hardened malloc](https://github.com/GrapheneOS/hardened_malloc).

    **Note**: If you're not using GRUB as your boot loader, you will need to apply the kernel arguments yourself, located in `etc/KARGS`.

#### Building the Package Yourself

You can build the package using this [PKGBUILD](https://github.com/prismos-org/PKGBUILDS/tree/master/hardened-configs).

### Other Linux Distributions

I do not provide packages for other Linux distributions so you will need to apply these configurations manually. You can know where every file and script goes by taking a look at the `TREE` file.

## License

This project is licensed under MIT.
See the [LICENSE](./LICENSE) file for details.

**Notice:**
Some configurations in this repository are derived from or inspired by the [secureblue](https://github.com/secureblue/secureblue), [GrapheneOS](https://github.com/GrapheneOS) and [Privsec](https://privsec.dev) projects.
Original authors and contributors retain their respective copyrights.
All modifications and additions are licensed under MIT unless otherwise noted.

## Contact

You can contact me via email or XMPP:
- [Email](mailto:nexus-x@tuta.io)
- XMPP: crabbymaniac@xmpp.is
- [PGP](https://nrz-21.github.io/key.txt)

## Useful Links

- [Arch Linux Security Wiki](https://wiki.archlinux.org/title/Security)
- [Privsec](https://privsec.dev/posts/linux/)
- [Kicksecure's Wiki](https://www.kicksecure.com/wiki/About)
- [Madaidan's Insecurities](https://madaidans-insecurities.github.io/)
