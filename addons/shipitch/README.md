<div align="center">
  <img src="shipitch_logo.png" alt="ShipItch Logo" width="150" />
  <h1>ShipItch</h1>
  <p><strong>One-Click Godot 4 to Itch.io Deployment Addon</strong></p>
  <br/>
  <img src="../../images/shipitch.png" alt="ShipItch Dock Interface" style="max-width: 100%; box-shadow: 0 4px 8px rgba(0,0,0,0.2);" />
</div>

**ShipItch** is a Godot 4 plugin that streamlines your game deployment process to itch. It enables completely automated, one-click exporting and uploading directly to your [itch.io](https://itch.io) projects without ever having to leave the Godot Editor.

## Features

 🚀 **One-Click Export & Push:** Build your Godot project and push it straight to itch.io in a single automated step.

![ShipItch Export Process](../../images/export.gif)

 🤖 **Automated Butler Setup:** Automatically detects, downloads, and configures [Butler](https://itch.io/docs/butler/) (itch.io's official CLI tool). No manual setup required!<br/>
  <img src="../../images/autobutlerdownload.png" alt="Automated Butler downloading process" width="500" />

🔑 **Integrated API Management:** Shortcut to get api, verification of api key, ...

🎯 **Export Preset Detection:** Reads export presets and maps your exports to the correct itch.io channels.

## 📥 Installation

### From Asset Library (Recommended)

1. Open Godot and head to the **AssetLib** tab.
2. Search for **ShipItch**.
3. Download and install.
4. Enable it in **Project -> Project Settings -> Plugins**.

### Manual Installation

1. Grab the `addons/shipitch` folder from this repo.
2. Drop it into your project's `addons/` directory.
3. Enable it in **Project -> Project Settings -> Plugins**.

## 🛠️ Usage

1. **API Key Setup:** Obtain an API Key from your itch.io account settings (use addon shortcut) and enter it into the ShipItch dock.
2. **Select Target Project:** Once authenticated, choose your target itch.io game.
3. **Configure Presets:** Ensure you have Godot export presets configured via **Project -> Export**.
4. **Ship It!:** Select your desired preset and click the push button.

## Contributing

Contributions, issues, and feature requests are always welcome! Feel free to check the issues page if you want to contribute.

## 📄 License

This project is open-source and available under the terms of the MIT License.
