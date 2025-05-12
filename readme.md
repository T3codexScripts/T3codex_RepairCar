# T3Dev_RepairCar

**By T3CodexTeam**

## Description

T3Dev_RepairCar is a comprehensive vehicle repair script for **QBCore** framework, integrated with **ox_inventory**. It allows players to repair their owned vehicles using a repair kit item, with immersive animations, progress bars, and synchronized hood actions for added realism. The script ensures that the vehicle's repaired state is saved persistently in the database.

## Features

- **Usable Repair Kit Item**: Players can use a repair kit item (`repair_kit`) to repair vehicles.
- **Immersive Animations**: Includes repair animations for players during the repair process.
- **Progress Bar**: Displays a configurable progress bar showing the repair duration.
- **Hood Actions**: The vehicle's hood opens when the repair starts and closes upon completion or cancellation.
- **Synchronization**: Repairs and hood actions are synchronized across all clients, ensuring all players see the same vehicle state.
- **Persistent Repairs**: Updates the vehicle's health in the database to ensure repairs persist after server restarts or when storing/retrieving the vehicle.
- **Localization Support**: Supports multiple languages through easy-to-edit locale files.
- **Configurable Settings**: Easy configuration through the `config.lua` file.

## Dependencies

- **QBCore Framework**
- **ox_inventory**
- **oxmysql**

## Installation

1. **Download and Place the Resource**

   - Download the `T3Dev_RepairCar` resource.
   - Place the `T3Dev_RepairCar` folder into your server's `resources` directory.

2. **Add to Server Configuration**

   - Open your `server.cfg` file.
   - Add the following line to ensure the resource starts:

     ```
     ensure T3Dev_RepairCar
     ```

3. **Configure the Script (Optional)**

   - Open the `config.lua` file inside the `T3Dev_RepairCar` folder.
   - Adjust the configuration settings as needed.

     ```lua
     Config = {}

     -- Localization
     Config.Locale = 'en' -- Available locales: 'en', 'es', 'fr', etc.

     -- Repair Settings
     Config.RepairTime = 15000 -- Repair time in milliseconds (1000 ms = 1 second)

     -- Item Settings
     Config.RepairKitItem = 'repair_kit' -- The item name for the repair kit
     ```

4. **Ensure Item Definition**

   - Make sure the `repair_kit` item is defined in your `ox_inventory` items file.

     **Example (`ox_inventory/data/items.lua`):**

     ```lua
     ['repair_kit'] = {
         label = 'Repair Kit',
         weight = 1000,
         stack = true,
         close = true,
         description = 'A kit to repair your vehicle',
         -- image = 'repairkit.png', -- Include if you have a custom image
     }
     ```

   - Ensure that the item name matches `Config.RepairKitItem`.

5. **Restart Your Server**

   - Fully restart your server to load the new resource and apply any configuration changes.

## Usage

1. **Obtaining a Repair Kit**

   - Players can obtain a repair kit through in-game means, such as purchasing from a shop or receiving from an admin.

2. **Using the Repair Kit**

   - Have the `repair_kit` item in your inventory.
   - Approach a damaged vehicle that you own.
   - Ensure you are not inside the vehicle.
   - Open your inventory and use the `repair_kit` item.
   - The repair process will begin:

     - The vehicle's hood will open.
     - An animation will play.
     - A progress bar will display the repair duration.
     - Movement and combat will be disabled during the repair.

3. **Repair Completion**

   - Upon successful completion:

     - The vehicle will be repaired.
     - The hood will close.
     - A notification will display "Vehicle repaired successfully!"
     - One `repair_kit` will be removed from your inventory.
     - The vehicle's repaired state will be saved to the database.

4. **Repair Cancellation**

   - If the repair is canceled (e.g., moving away), the hood will close, and a notification will display "Repair cancelled."

## Configuration

All configuration options are located in the `config.lua` file.

### Localization

- **Config.Locale**

  - Sets the default language for notifications and messages.
  - Available locales are defined in the `locales` folder.
  - Example: `'en'` for English.

### Repair Settings

- **Config.RepairTime**

  - Sets the duration of the repair process in milliseconds.
  - Default is `15000` (15 seconds).
  - Adjust to make the repair process shorter or longer.

### Item Settings

- **Config.RepairKitItem**

  - Sets the item name for the repair kit.
  - Must match the item defined in `ox_inventory`.
  - Default is `'repair_kit'`.

## Localization

The script supports multiple languages through locale files.

- **Default Locale**: English (`en`)
- **Adding a New Locale**:

  1. Create a new file in the `locales` folder (e.g., `locales/es.lua` for Spanish).
  2. Copy the contents of `en.lua` and translate the messages.
  3. Update `Config.Locale` in `config.lua` to the new locale code.

- **Example `locales/en.lua`**:

  ```lua
  -- Ensure that Locales is initialized
  Locales = Locales or {}

  Locales['en'] = {
      -- Notifications
      ['vehicle_repaired'] = 'Vehicle repaired successfully!',
      ['repair_failed'] = 'Repair failed!',
      ['repair_cancelled'] = 'Repair cancelled',
      ['no_vehicle_nearby'] = 'No vehicle nearby',
      ['cannot_repair_in_vehicle'] = 'You cannot repair from inside the vehicle',
      ['no_repair_kit'] = 'No repair kit found',

      -- Progress Bar
      ['repairing_vehicle'] = 'Repairing vehicle...',
  }
  ```

## Troubleshooting

- **Repair Kit Not Being Used**

  - Ensure the `repair_kit` item is correctly defined in `ox_inventory`.
  - Verify that the item name matches `Config.RepairKitItem`.

- **Vehicle Not Being Repaired**

  - Confirm that you are the owner of the vehicle.
  - Ensure the vehicle is damaged.
  - Check for errors in the client (`F8`) and server consoles.

- **Repair Kit Not Being Removed**

  - Ensure that the server script uses `Player.Functions.RemoveItem` to remove the repair kit.
  - Verify that the item name matches in all scripts and `ox_inventory`.

- **Localization Issues**

  - Make sure `Config.Locale` matches one of the locale files in the `locales` folder.
  - Verify that all necessary keys are present in the locale file.

## Notes

- **Vehicle Ownership**

  - The script updates the vehicle's state in the database, so it must be an owned vehicle.
  - Unowned or AI vehicles may not be repaired or have their state saved.

- **Network Synchronization**

  - The script ensures that all players see the same vehicle state, including repairs and hood actions.
  - Proper network synchronization is handled through server and client events.

- **Dependencies**

  - Ensure all dependencies are properly installed and configured.
  - The script relies on QBCore functions, which may be overridden by `ox_inventory`.

## Credits

**By T3DevTeam**

- Script developed and maintained by T3DevTeam.
- Contributions and support are welcome.

## License

This project is licensed under the terms you specify (if any). If not specified, consider adding a license to clarify the terms of use.

---

If you need further assistance or have any questions, feel free to reach out to T3DevTeam.
