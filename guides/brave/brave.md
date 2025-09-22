# Hardening Brave Browser

Brave is probably the only browser on Linux that is reasonably private and secure. It is built on top of Chromium, meaning it has comparatively better sandboxing than Firefox or its forks [[1](https://grapheneos.org/usage#web-browsing)][[2](https://madaidans-insecurities.github.io/firefox-chromium.html)]. You can opt out of telemetry; they have a good update cycle, CVEs are patched relatively fast, and they have decent anti-fingerprinting protection that can fool naive scripts. Currently, the Tor Browser’s approach to anti-fingerprinting is the only one with real potential.
This guide provides a clear approach to hardening the Brave browser by disabling telemetry, removing features that can be termed bloat, and enabling privacy-focused settings. While primarily focused on Linux, it should apply on all platforms. You will find the `Local State` and `Preferences` file In `configs/` Implementing most of hardening stated below, however It does not change the shield settings and due to a weird bug the search engine's set to Google even If I set It to another one.

**Note:**
- For fingerprinting blocking at Strict level, enable the relevant flag first (see Flags section).

# Customize Dashboard (brave://newtab)

1. Disable Sponsored Images.
2. Disable Cards.

# Brave Settings (brave://settings)

### Appearance
1. Disable Brave News, Rewards, and the Sidebar button.  
2. Disable Auto Suggestions to prevent sending partial queries to servers.
### Shields
1. Set Trackers & Ads Blocking to **Aggressive**.  
2. Set Upgrade Connections to HTTPS to **Strict**.  
3. **Set Block Fingerprinting to Strict:** this requires enabling the flag `#brave-show-strict-fingerprinting-mode` first (see Flags).  
4. Disable **Store Contact Info for Future Broken Site Reports**.
### Privacy and Security
1. **Disable Safe Browsing:** it sends partial URL hashes to Google for malware checks (anonymized but still involves Google). Use common sense.  
2. **Enable Secure DNS** and set provider to **OS Default**.
3. **Disable the V8 JS Optimizer** to reduce attack surface.  
4. Set **WebRTC IP Handling Policy** to **Disable Non-Proxied UDP**.  
5. Disable Tor windows (Tor tabs).  
6. **Disable All Data Collection:** Settings > Privacy and security > Data collection > uncheck all (e.g., Send usage stats, Diagnostic reports).
### Web3
1. Set default Ethereum and Solana wallets to **Extensions (No Fallback)**.  
2. Disable resolution of all Web3 domains.
### Autofill and Passwords
1. Disable all autofill methods; built-in autofill is not safe. Use KeePassXC or VaultWarden (You can store addresses and card details as notes).
### Languages
1. **Disable Spell Check and Brave Translate:** spell check may send text snippets; Translate processes content on servers (Anonymized but better to avoid).
### Search Engines
1. Use a self-hosted SearxNG instance or Mullvad Leta as your search engine. Mullvad Leta runs on RAM-only servers and is accessible as an onion service.  
2. Disable **Improve Search Suggestions**.  
3. Disable **Web Discovery Project**.
### System
1. Disable **Continue Running Background Apps When Brave Is Closed**.  
2. Disable **Hardware Graphics Acceleration** to reduce the attack surface.
## Flags (brave://flags)

| Flag                                                             | Setting                                                             | Rationale                                                                                                   |
| ---------------------------------------------------------------- | ------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| `#brave-rewards-allow-self-custody-providers`                    | Disabled                                                            | Disable Brave Rewards.                                                                                      |
| `#brave-rewards-platform-creator-detection`                      | Disabled                                                            | Disable Brave Rewards.                                                                                      |
| `#brave-ads-allowed-to-fallback-to-custom-push-notification-ads` | Disabled                                                            | Disable Brave Ads.                                                                                          |
| `#brave-block-screen-fingerprinting`                             | Enabled                                                             | Improve anti-fingerprinting.                                                                                |
| `#brave-show-strict-fingerprinting-mode`                         | Enabled                                                             | Enable 'Strict' fingerprinting mode.                                                                        |
| `#native-brave-wallet`                                           | Disabled                                                            | Disable Brave Wallet.                                                                                       |
| `#brave-wallet-zcash`                                            | Disabled                                                            | Disable Brave Wallet.                                                                                       |
| `#brave-wallet-bitcoin`                                          | Disabled                                                            | Disable Brave Wallet.                                                                                       |
| `#brave-wallet-cardano`                                          | Disabled                                                            | Disable Brave Wallet.                                                                                       |
| `#brave-news-peek`                                               | Disabled                                                            | Disable Brave News.                                                                                         |
| `#brave-news-feed-update`                                        | Disabled                                                            | Disable Brave News.                                                                                         |
| `#brave-rewards-gemini`                                          | Disabled                                                            | Disables Brave Rewards.                                                                                     |
| `#brave-ai-chat`                                                 | Disabled                                                            | Disables Brave Leo AI.                                                                                      |
| `#brave-ai-chat-history`                                         | Disabled                                                            | Disables Brave Leo AI.                                                                                      |
| `#brave-ai-host-specific-distillation`                           | Disabled                                                            | Disables Brave Leo AI.                                                                                      |
| `#brave-ai-chat-context-menu-rewrite-in-place`                   | Disabled                                                            | Disables Brave Leo AI.                                                                                      |
| `#brave-ai-chat-open-leo-from-brave-search`                      | Disabled                                                            | Disables Brave Leo AI.                                                                                      |
| `#brave-ai-chat-web-content-association-default`                 | Disabled                                                            | Disables Brave Leo AI.                                                                                      |
| `#strict-origin-isolation`                                       | Enabled                                                             | Isolates origins for better site isolation. Improves security.                                              |
| `#origin-keyed-processes-by-default`                             | Enabled                                                             | Enables origin-keyed process isolation.                                                                     |
| `#sync-autofill-wallet-credential-data`                          | Disabled                                                            | Disables Brave Wallet.                                                                                      |
| `#partition-alloc-with-advanced-checks`                          | Enabled on browser and renderer processes (or all for max security) | Enables advanced memory allocator checks for exploit mitigation.                                            |
| `#reduce-accept-language`                                        | Enabled                                                             | Reduces the amount of information in the Accept-Language request header and JavaScript navigator.languages. |
| `#reduce-accept-language-http`                                   | Enabled                                                             | Reduces information in the Accept-Language request header only.                                             |
| `#autofill-enable-cvc-storage-and-filling`                       | Disabled                                                            | Disables CVC storage and filling for payment autofill.                                                      |
| `#prompt-api-for-gemini-nano-multimodal-input`                   | Disabled                                                            | Disable Prompt API for Gemini Nano.                                                                         |
