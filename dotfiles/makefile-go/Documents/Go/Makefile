APP_NAME := $(shell basename $(CURDIR))

# ==================================================================================== #
# CONFIGURATION - Do not change
# ==================================================================================== #

# Include and export environment variables from build.env
# These are set by running 'make config' or 'make init'
# The '-' prefix suppresses errors if the file doesn't exist yet.
-include build.env
export

# ==================================================================================== #
# VARIABLES - You can change these variables to suit your needs
# ==================================================================================== #

# These are now default values.
# Run 'make config' to configure and save your preferences to 'build.env'.
# You can also override them on the command line (e.g., make run ARGS="-foo")

# Go binary that you want to use.
# Example: go1.21.10
# To use the default version installed on your system, use "go" without any version number
GO ?= go

# Local development variables
# --------------------------
# Accepted Values
# - windows
# - darwin
# - linux
OS ?= linux
ARCH ?= amd64
MAIN_PACKAGE ?= github.com/dorudumitru/$(APP_NAME)
# The path to the folder where main.go resides.
# Example: ./cmd/my-app
MAIN_PACKAGE_PATH ?= .
# Lint with golangci-lint? yes/no
USE_GOLANGCI_LINT ?= yes

# Use if the app requires flags (ex: -u username -p password)
# This is the default, but can be overridden on the command line:
# make run ARGS="-u user -p pass"
ARGS ?= 

# Production build variables
# --------------------
# Accepted Values
# - windows
# - darwin
# - linux
GOOS ?= linux
# Run "go tool dist list" for all possible values
GOARCH ?= amd64

# ==================================================================================== #
# VARIABLES - Do not change these variables
# ==================================================================================== #

EXT_windows := .exe
EXT_darwin :=
EXT_linux :=

DEV_BINARY_NAME := $(APP_NAME)$(EXT_$(OS))
DEV_BINARY_PATH := /tmp/bin/$(DEV_BINARY_NAME)
BINARY_NAME := $(APP_NAME)$(EXT_$(GOOS))

# Error checking
ifneq ($(filter windows darwin linux,$(OS)),$(OS))
	$(error OS is not supported)
endif
ifneq ($(filter windows darwin linux,$(GOOS)),$(GOOS))
	$(error GOOS is not supported)
endif
ifneq ($(filter yes no,$(USE_GOLANGCI_LINT)),${USE_GOLANGCI_LINT})
	$(error USE_GOLANGCI_LINT must be yes or no)
endif

# ==================================================================================== #
# HELPERS
# ==================================================================================== #

## help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'

.PHONY: confirm
confirm:
	@echo -n 'Are you sure? [y/N] ' && read ans && [ $${ans:-N} = y ]

.PHONY: no-dirty
no-dirty:
	git diff --exit-code

.PHONY: clean
clean:
	@rm -rf dist

## go/version/sync: syncronyze go binary with the version specified in the Makefile
.PHONY: go/version/sync
go/version/sync:
	@if [ ! "${GO}" == "go" ]; then \
		echo "Syncing Go version..."; \
		go install golang.org/dl/${GO}@latest; \
		${GO} download; \
	fi

## config: (Re)configure project variables and save to build.env
.PHONY: config
config:
	@echo -e "\nConfiguring build variables (press Enter to accept default):"
	
	@echo -e "\nGo binary that you want to use."
	@echo "Example: go1.21.10"
	@echo "To use the default version installed on your system, use \"go\" without any version number"
	@read -p "Enter Go binary [${GO}]: " go_val; \
	echo "GO := $${go_val:-${GO}}" > build.env

	@echo -e "\nLocal development OS."
	@echo "Accepted Values: windows/darwin/linux"
	@read -p "Enter local development OS [${OS}]: " os_val; \
	echo "OS := $${os_val:-${OS}}" >> build.env

	@echo -e "\nLocal development architecture."
	@read -p "Enter local development ARCH (e.g., amd64, arm64) [${ARCH}]: " arch_val; \
	echo "ARCH := $${arch_val:-${ARCH}}" >> build.env

	@echo -e "\nGo module path (e.g., github.com/user/repo)."
	@read -p "Enter Go module path [${MAIN_PACKAGE}]: " main_pkg_val; \
	echo "MAIN_PACKAGE := $${main_pkg_val:-${MAIN_PACKAGE}}" >> build.env

	@echo -e "\nThe path to the folder where main.go resides."
	@echo "Example: ./cmd/my-app"
	@read -p "Enter path to main.go [${MAIN_PACKAGE_PATH}]: " main_path_val; \
	echo "MAIN_PACKAGE_PATH := $${main_path_val:-${MAIN_PACKAGE_PATH}}" >> build.env

	@echo -e "\nLint with golangci-lint?"
	@read -p "Accepted values: yes/no [${USE_GOLANGCI_LINT}]: " lint_val; \
	echo "USE_GOLANGCI_LINT := $${lint_val:-${USE_GOLANGCI_LINT}}" >> build.env

	@echo -e "\nUse if the app requires flags (ex: -u username -p password)."
	@echo "Can be left blank, or can be overridden on the command line:"
	@echo "make run ARGS=\"-u user -p pass\""
	@read -p "Enter default run arguments [${ARGS}]: " args_val; \
	echo "ARGS := $${args_val:-${ARGS}}" >> build.env

	@echo -e "\nProduction build OS."
	@echo "Accepted Values: windows/darwin/linux"
	@read -p "Enter production build OS [${GOOS}]: " goos_val; \
	echo "GOOS := $${goos_val:-${GOOS}}" >> build.env

	@echo -e "\nProduction build architecture."
	@echo "Run \"go tool dist list\" for all possible values"
	@read -p "Enter production build ARCH (e.g., amd64, arm64) [${GOARCH}]: " goarch_val; \
	echo "GOARCH := $${goarch_val:-${GOARCH}}" >> build.env

	@echo -e "\nConfiguration saved to build.env"

## init: initialize the project (runs config and one-time setup)
.PHONY: init
init:
	@$(MAKE) config
	@$(MAKE) init/after-config

.PHONY: init/after-config
init/after-config: go/version/sync
	@if [ "${USE_GOLANGCI_LINT}" = "yes" ] && ! command -v "golangci-lint" &> /dev/null; then \
		echo "Please install 'golangci-lint' from https://golangci-lint.run/docs/welcome/install/ to continue."; \
		exit 1; \
	fi
	@echo "Initializing project..."
	@echo "Project name: ${APP_NAME}"
	@echo -e "\nInitializing git repository..."
	@if [ ! -d .git ]; then git init; fi
	@touch .gitignore
	@grep -qxF "dist/" .gitignore || echo "dist/" >> .gitignore
	@grep -qxF ".idea/" .gitignore || echo ".idea/" >> .gitignore
	@grep -qxF ".vscode/" .gitignore || echo ".vscode/" >> .gitignore
	@grep -qxF "build.env" .gitignore || echo "build.env" >> .gitignore
	@echo -e "\nInitializing Go module..."
	@if [ ! -f go.mod ]; then ${GO} mod init ${MAIN_PACKAGE}; fi
	@echo -e "package path: ${MAIN_PACKAGE_PATH}"
	@mkdir -p ${MAIN_PACKAGE_PATH}
	@if [ ! -f "${MAIN_PACKAGE_PATH}/main.go" ]; then touch ${MAIN_PACKAGE_PATH}/main.go; fi
	@if [ "${USE_GOLANGCI_LINT}" = "yes" ]; then \
		echo -e "\nDownloading golangci-lint config..."; \
		if [ ! -f .golangci.yml ]; then curl -s -O https://gist.githubusercontent.com/maratori/47a4d00457a92aa426dbd48a18776322/raw/ae78780d0653027c1c83d3a705cfda028afc1a5b/.golangci.yml; fi; \
	else \
		echo -e "\nSkipping golangci-lint setup (disabled)."; \
	fi
	@echo -e "\nDone."
	
# ==================================================================================== #
# QUALITY CONTROL
# ==================================================================================== #

## lint: run golangci-lint
.PHONY: lint
lint:
	@if [ "${USE_GOLANGCI_LINT}" = "yes" ]; then \
		echo "Linting code..."; \
		if ! command -v "golangci-lint" &> /dev/null; then \
			echo "Please install 'golangci-lint' from https://golangci-lint.run/docs/welcome/install/ to continue."; \
			exit 1; \
		fi; \
		golangci-lint run; \
	else \
		echo "Skipping lint (USE_GOLANGCI_LINT=${USE_GOLANGCI_LINT})."; \
	fi

## tidy: format code and tidy modfile
.PHONY: tidy
tidy:
	@echo "Formatting code and tidying modfile..."
	@${GO} mod tidy -v
	@${GO} fmt ./...

## audit: run quality control checks
.PHONY: audit
audit:
	@echo "Auditing dependencies and code..."
	@${GO} mod verify
	@${GO} vet ./...
	@${GO} run golang.org/x/vuln/cmd/govulncheck@latest ./...
	@echo -e "Running tests with race detector...\n"
	@${GO} test -race -buildvcs -vet=off ./...

# ==================================================================================== #
# DEVELOPMENT
# ==================================================================================== #

## test: run all unit tests
.PHONY: test
test:
	@echo -e "Running tests...\n"
	@${GO} test -v -race -buildvcs ./...

## test/integration: run all tests including integration
.PHONY: test/integration
test/integration:
	# include integration tests steps here...

## test/cover: run all tests and display coverage
.PHONY: test/cover
test/cover:
	@echo -e "Running tests and generating coverage report...\n"
	@${GO} test -v -race -buildvcs -coverprofile=/tmp/coverage.out ./...
	@${GO} tool cover -html=/tmp/coverage.out

## build: build the application
# include additional build steps, like TypeScript, SCSS or Tailwind compilation here...
.PHONY: build
build:
	@echo "Building development binary to $(DEV_BINARY_PATH)..."
	@mkdir -p /tmp/bin
	@${GO} build -o $(DEV_BINARY_PATH) ${MAIN_PACKAGE_PATH}

## run: run the  application
.PHONY: run
run: lint build
	@echo -e "Running application...\n"
	@$(DEV_BINARY_PATH) ${ARGS}

## run/no-lint: run the  application without linting
.PHONY: run/no-lint
run-no-lint: build
	@echo -e "Running application (no-lint)...\n"
	@$(DEV_BINARY_PATH) ${ARGS}

## watch: run the application with reloading on file changes
.PHONY: watch
watch: lint
	@echo "Watching for file changes..."
	@${GO} run github.com/cosmtrek/air@latest \
		--build.cmd "make build" \
		--build.bin "$(DEV_BINARY_PATH) ${ARGS}" \
		--build.delay "100" \
		--build.exclude_dir "dist" \
		--build.include_ext "go, tpl, tmpl, html, css, scss, js, ts, sql, jpeg, jpg, gif, png, bmp, svg, webp, ico" \
		--misc.clean_on_exit "true"

# ==================================================================================== #
# OPERATIONS
# ==================================================================================== #

## production: create a production build of the application
.PHONY: prod
prod: clean lint tidy audit no-dirty
	@echo "Creating production build for $(GOOS)/$(GOARCH)..."
	@GOOS=${GOOS} GOARCH=${GOARCH} ${GO} build -ldflags='-s' -o dist/${GOOS}_${GOARCH}/${APP_NAME}/${BINARY_NAME} ${MAIN_PACKAGE_PATH}
	@if command -v upx &> /dev/null; then \
		echo "Compressing binary with upx..."; \
		upx -5 ./dist/${GOOS}_${GOARCH}/${APP_NAME}/${BINARY_NAME}; \
	else \
		echo "Warning: upx not found. Skipping binary compression."; \
	fi

## deploy: deploy the application to production
.PHONY: deploy
deploy:
	# include deployment steps here...
