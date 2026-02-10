# Makefile for Daikin Airbase Edge Driver

DRIVER_NAME = daikin-airbase
CLI = smartthings

.PHONY: all package install logcat test create-channel enroll-channel assign-driver setup

all: test package install

setup: test create-channel enroll-channel package assign-driver install
	@echo "Setup and deployment complete!"

package:
	$(CLI) edge:drivers:package .

create-channel:
	$(CLI) edge:channels:create

enroll-channel:
	$(CLI) edge:channels:enroll

assign-driver:
	$(CLI) edge:channels:assign

install:
	$(CLI) edge:drivers:install

logcat:
	$(CLI) edge:drivers:logcat

test:
	@echo "Running tests..."
	@lua test/test_controller.lua
	@lua test/test_state.lua
	@lua test/test_daikin.lua
	@lua test/test_lifecycle.lua
	@echo "All tests passed!"
