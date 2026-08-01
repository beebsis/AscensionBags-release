# Installing AscensionBags

## Requirements

- World of Warcraft 3.3.5a client (Ascension)
- Both `AscensionBags` and `Syndicator335` folders from this repo. AscensionBags is the bag/bank UI, Syndicator335 is the data tracking layer it depends on. Neither works without the other.

## Steps

1. Download this repo.
   - Easiest: click the green "Code" button on GitHub, then "Download ZIP", and unzip it.
   - Or clone it: `git clone https://github.com/beebsis/AscensionBags-release.git`
2. Copy both the `AscensionBags` folder and the `Syndicator335` folder into your WoW client's `Interface/AddOns/` directory.
   - After copying, you should have `Interface/AddOns/AscensionBags/` and `Interface/AddOns/Syndicator335/` sitting side by side, each with its own `.toc` file directly inside it.
3. Fully restart the WoW client (exit to desktop and relaunch, or at minimum log out to the character select screen). A `/reload` right after copying in new files is not always enough.
4. On the character select screen, open the AddOns list and enable both `AscensionBags` and `Syndicator335`.
5. Log in. Use `/ascbags` (or `/abags`) to open the bag window, and `/ascbags options` to open settings.

## Updating

Download the latest version the same way and overwrite both folders. Your saved settings, categories, and profiles are stored separately by the WoW client and are not affected by overwriting the addon files.

## Troubleshooting

- "attempt to call a nil value" errors right after installing: you likely only used `/reload`. Do a full client restart instead.
- Bags window will not open: make sure both `AscensionBags` and `Syndicator335` are enabled on the character select AddOns screen, not just one of them.
