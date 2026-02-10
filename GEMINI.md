# SmartThings Edge Driver: Daikin Airbase (SkyFi)

This project is a SmartThings Edge driver for Daikin Airbase (SkyFi) BRP15B61 units, written in Lua. It allows control of Daikin HVAC systems through the SmartThings platform using LAN communication.

## Project Overview

- **Purpose:** Provide an Edge-based integration for Daikin Airbase controllers.
- **Main Technologies:** Lua, SmartThings Edge SDK, LAN (HTTP/UDP).
- **Architecture:** 
    - **Discovery:** Uses UDP broadcast (`DAIKIN_UDP/common/basic_info`) on port 30050 to find devices.
    - **Communication:** Communicates with the controller via an HTTP API (`/skyfi/...`).
    - **Device Model:** Creates a main unit and two child devices for indoor and outdoor temperature sensors.
    - **State Management:** Maps internal Daikin attributes to SmartThings capabilities (Switch, Thermostat Mode, Fan Mode, Setpoints, Temperature Measurement).

## Directory Structure

- `src/`: Core logic for the Edge driver.
    - `init.lua`: Driver entry point and capability handler registration.
    - `daikin.lua`: HTTP API client for the SkyFi controller.
    - `discovery.lua`: LAN discovery logic.
    - `ui.lua`: State orchestration and event emission.
    - `controller.lua`: Command translation (SmartThings -> Daikin).
    - `state.lua`: State translation (Daikin -> SmartThings).
    - `lifecycle.lua`: Device lifecycle handlers (`init`, `added`, `removed`).
- `profiles/`: YAML definitions of device capabilities and UI presentation.
- `config.yml`: Driver metadata and required permissions (LAN, Discovery).

## Building and Running

This driver requires the [SmartThings CLI](https://developer.smartthings.com/docs/sdks/cli/introduction).

A `Makefile` is provided to automate common tasks.

### Key Commands

- `make setup`: The complete onboarding flow (test, create channel, enroll hub, package, assign, and install). Best for first-time setup.
- `make test`: Runs Lua unit tests located in the `test/` directory.
- `make package`: Packages the driver using the SmartThings CLI.
- `make create-channel`: Interactive wizard to create a new Edge driver channel.
- `make enroll-channel`: Enrolls the hub in a channel.
- `make assign-driver`: Assigns the packaged driver to a channel.
- `make install`: Installs the driver to the default hub.
- `make logcat`: Shows live logs from the hub.
- `make all`: Runs tests, packages, and installs the driver.

## Testing

Unit tests are written in Lua and located in the `test/` directory. They use a mock SmartThings environment (`test/mock_st.lua`) and mock network calls (`test/mock_cosock.lua`) to verify the logic.

Covered modules:
- `controller.lua`: Command to attribute mapping.
- `state.lua`: Attribute to capability state mapping.
- `daikin.lua`: API communication and parsing (mocked network).
- `lifecycle.lua`: Device initialization and cleanup.

To run tests:
```bash
make test
```

## Development Conventions

- **Language:** Lua 5.3 (as per SmartThings Edge environment).
- **Asynchronous I/O:** Uses the `cosock` library for non-blocking network operations.
- **Modularity:** Logic is split into functional modules (discovery, API, translation, lifecycle).
- **Error Handling:** Implements retries for network commands and marks devices offline on persistent failures.
- **Constants:** Shared constants (attributes, fields, modes) are isolated in dedicated files for maintainability.
