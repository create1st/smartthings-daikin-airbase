<div style="text-align: center;">    
 <img src="https://img.shields.io/github/license/create1st/smartthings-daikin-airbase.svg" alt="License" />
 <img src="https://img.shields.io/badge/smartthings-blue.svg" alt="SmartThings" />
 <img src="https://img.shields.io/badge/LUA_API_v10_Hub_Release-0.53.X-green.svg" alt="Lua API" />
 <img src="https://img.shields.io/badge/PRs-welcome-green.svg" alt="PRs Welcome" />
</div>

# Daikin Airbase BRP15B61 Edge Handler for SmartThings

| Device Discovery | Main Unit | Temperature Sensor |
| :---: | :---: | :---: |
| <img src="documentation/discovery.png" alt="Device discovery" width="250"> | <img src="documentation/unit.png" alt="Main unit" width="250"> | <img src="documentation/sensor.png" alt="Temperature sensor" width="250"> |

### Disclaimer

All product and company names or logos are trademarks™ or registered® trademarks of their respective holders. 
Their use does not imply affiliation with or endorsement by them or any associated subsidiaries!
**Daikin** is a trademark of **Daikin Industries, Ltd**. **SmartThings** is a trademark of **SmartThings Inc.** a subsidiary of **Samsung Electronics**.

This personal project has an educational context, is developed as a proof of concept, and has no business goal.
The author is not responsible for the harm or damage caused by using this software. You may use it at your own risk and responsibility only.

### Resources

- [Daikin Control (Node.js)](https://github.com/ael-code/daikin-control)
- [Daikin Controller (Node.js)](https://github.com/Apollon77/daikin-controller)
- [SmartThings Edge Device Drivers](https://developer.smartthings.com/docs/edge-device-drivers/)
- [Edge Architecture](https://developer.smartthings.com/docs/devices/hub-connected/edge-architecture)
- [First Lua Driver Tutorial](https://developer.smartthings.com/docs/devices/hub-connected/first-lua-driver)
- [Capabilities Reference](https://developer.smartthings.com/docs/devices/capabilities/capabilities-reference)
- [Custom Capabilities](https://developer.smartthings.com/docs/devices/capabilities/custom-capabilities)

### Dependencies

- [SmartThings CLI](https://developer.smartthings.com/docs/sdks/cli/introduction)
- [SmartThings Edge Drivers SDK](https://github.com/SmartThingsCommunity/SmartThingsEdgeDrivers/releases/tag/apiv9_52)

### Installation

#### Uploading Your Driver to SmartThings

For a simplified setup, use the provided `Makefile`:
```bash
make setup
```

Or manually follow these steps:

1. **Create a Channel:**
   ```bash
   smartthings edge:channels:create
   ```

2. **Enroll Your Hub:**
   ```bash
   smartthings edge:channels:enroll
   ```

3. **Assign the Driver to the Channel:**
   ```bash
   smartthings edge:channels:assign
   ```

4. **Install the Driver on Your Hub:**
   ```bash
   smartthings edge:drivers:install
   ```

#### Accessing Live Logs

To see what the driver is doing in real-time:
```bash
make logcat
```
Or manually:
```shell
smartthings edge:drivers:logcat
```

### Development

A `Makefile` is provided for common development tasks:
- `make setup`: Run the **full** onboarding flow (First time).
- `make test`: Run Lua unit tests.
- `make package`: Package the driver.
- `make create-channel`: Create a new channel (interactive).
- `make enroll-channel`: Enroll hub in channel (interactive).
- `make assign-driver`: Assign driver to channel (interactive).
- `make install`: Install the driver to the hub.
- `make logcat`: Access live logs.

#### Running Tests
```bash
make test
```

### Onboarding Your New Device

Once the driver is installed on your hub:

1. Open the **SmartThings App**.
2. Go to the **Location** where the Hub is installed.
3. Select **Add (+)** and then **Device**.
4. Tap on **"Scan nearby"**.
5. Check the logs in your `logcat` session to verify discovery.
6. The device should appear in your SmartThings app.