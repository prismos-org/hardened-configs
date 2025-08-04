# hardened-configs

## Overview

**hardened-configs** configuration files and scripts used in Prism OS, applicable to almost any Linux distribution to enhance security and reduce attack surface.

## Details for Nerds

- **Scripts**: Located in `bin/`. These are wrapper scripts around programs like `curl` and `wget` to protect against HTTPS downgrade attacks, ensures TLS 1.3 is always used, and changes the user agent to that of a real browser. Additionally, there's also a `scurlt` script (curl over Tor) for making requests to onion services.  
  There's also a `setup` script which disables and masks various services like geoclue, cups and avahi, renames the hostname to `localhost` and the username to `user` to minimize information leakage. The script also deletes binaries like `sudo`, `su`, `ksu`, and `pkexec`, and removes the SETUID and SETGID bits from binaries, granting necessary binaries capabilities instead. Use `run0` to escalate privileges to root instead. A rule in `etc/polkit-1/rules.d/` enables the persist feature, though it may not function until an update containing this [PR](https://github.com/polkit-org/polkit/pull/533) is rolled out.

- **Configurations**: Located in `etc/`. These configurations improve the security of your machine and reduce its attack surface. Key changes include:
  - Replacing the machine ID with a generic one (used by WHONIX).
  - Blacklisting several kernel modules to reduce attack surface.
  - Various sysctl values for system hardening. (see: `etc/sysctl.d/60-hardening.conf`)
  - Setting the default umask to `0077`.
  - Implementing per-network MAC randomization, a unique DUID (DHCP unique identifier) per connection, and a script to disable hostname broadcasting (note: this only works with MAC randomization enabled and from the second connection).
  - Setting the default DNS server to Mullvad's, with DNS over TLS and DNSSEC enabled (see: `etc/resolved.conf`).
  - Restricting the number of processes that can be forked to mitigate fork bombs (see: `etc/security/limits.conf`).
  - Implementing faillock to limit consecutive authentication attempts, with a default value of 30 (see: `etc/security/faillock.conf`).
  - Allowing only users in the 'wheel' or 'adm' group to escalate privileges to root; on some distributions, the 'wheel' group is 'root' (edit `etc/security/access.conf` as needed).
  - Enforcing strong passwords using the pwquality PAM module (see: `etc/pam.d/passwd`).
  - Using NTS servers instead of unencrypted NTP servers (see: `/etc/chrony.conf`).
  - Applying kernel arguments (located in `etc/KARGS`) that provide mitigations against various vulnerabilities like spectre and DMA and reduce the attack surface.

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
    The script automatically backs up your current GRUB config to `/etc/default/grub.bak`, but just to make sure make a backup of it yourself. You may need to remove conflicting files for a successful installation. The package also installs [pusbctl](https://github.com/prismos-org/pusbctl) a tool for protecting against rogue USB devices like a rubber ducky, AppArmor, chrony, and [hardened malloc](https://github.com/GrapheneOS/hardened_malloc).

    **Note**: If you're not using GRUB as your boot loader, you will need to apply the kernel arguments yourself, located in `etc/KARGS`.

#### Building the Package Yourself

You can build the package using this [PKGBUILD](https://github.com/prismos-org/PKGBUILDS/tree/master/hardened-configs).

### Other Linux Distributions

We do not provide packages for other Linux distributions so you will need to apply these configurations manually. You can know where every file and script goes by taking a look at the `TREE` file.

## Tips

- Fully encrypt your disk.
- Encrypt the boot partition as well if possible.
- Use [hardened malloc](https://github.com/GrapheneOS/hardened_malloc) instead of the default glibc malloc. (**Hardened malloc is installed and setup to be preload automatically when installed through the package.**)
- Use a trusted VPN (like Mullvad) and use a kill switch.
- If you're still using closed source applications from big techs, you may be secure but not private. There are alternatives, use them.
- Use a firewall and close any open ports which you haven't purposefully opened.
- `Be a little paranoid. And be suspicious. If anything sounds too good to be true, it probably is!` - Arch WIKI
- The weakest link will always be you, the user. Be conscious of your actions.
- Follow [the principle of least privilege](https://en.wikipedia.org/wiki/Principle_of_least_privilege)

## License

This is licensed under the GNU General Public License v3.0. See the [LICENSE](LICENSE) file for details.

## Contact

You can contact me via email or XMPP:
- [Email](mailto:nexus-x[at]tuta[dot]io)
- XMPP: nexus-x@xmpp.is
- [PGP](https://nrz-21.github.io/key.txt)

## Useful Links

- [Arch Linux Security Wiki](https://wiki.archlinux.org/title/Security)
- [Privsec](https://privsec.dev/posts/linux/)
- [Kicksecure's Wiki](https://www.kicksecure.com/wiki/About)
- [Madaidan's Insecurities](https://madaidans-insecurities.github.io/)
