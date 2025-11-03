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
# Absolute path of the go clidriver.
# Example: /home/user/Documents/go_ibm_db
GO_IBM_DB_PATH ?= /home/$(USER)/Documents/go_ibm_db


# Local development variables
# --------------------------
# Accepted Values
# - darwin
# - linux
OS ?= linux
ARCH ?= amd64
MAIN_PACKAGE ?= github.ibm.com/hartehanks-iasi/$(APP_NAME)
# The path to the folder where main.go resides.
# Example: ./cmd/my-app
MAIN_PACKAGE_PATH ?= .
# Absolute path of the .arm certificate
CERTIFICATE_PATH ?= /home/$(USER)/Documents/TrustStore/etl.arm

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

SCRIPT_windows := .bat
SCRIPT_darwin := .sh
SCRIPT_linux := .sh

CLIDRIVER_windows_archive := ntx64_odbc_cli.zip
CLIDRIVER_darwin_archive := macos64_odbc_cli.tar.gz
CLIDRIVER_linux_archive := linuxx64_odbc_cli.tar.gz

# dev
DEV_BINARY_NAME := $(APP_NAME)$(EXT_$(OS))
DEV_CLIDRIVER_NAME := $(CLIDRIVER_$(OS)_archive)
DEV_BINARY_PATH := /tmp/bin/$(DEV_BINARY_NAME)


# prod
BINARY_NAME := $(APP_NAME)$(EXT_$(GOOS))
CLIDRIVER_NAME := $(CLIDRIVER_$(OS)_archive)
START_SCRIPT_NAME := run$(SCRIPT_$(OS))

# Error checking
ifneq ($(filter darwin linux,$(OS)),$(OS))
	$(error OS is not supported)
endif
ifneq ($(filter windows darwin linux,$(GOOS)),$(GOOS))
	$(error GOOS is not supported)
endif


# ifeq ($(OS),darwin)
# 	DEV_BINARY_NAME := $(APP_NAME)
# 	DEV_CLIDRIVER_NAME := macos64_odbc_cli.tar.gz
# else ifeq ($(OS),linux)
# 	DEV_BINARY_NAME := $(APP_NAME)
# 	DEV_CLIDRIVER_NAME := linuxx64_odbc_cli.tar.gz
# else
# 	$(error OS is not supported)
# endif
#
# ifeq ($(GOOS),windows)
# 	BINARY_NAME := $(APP_NAME).exe
# 	CLIDRIVER_NAME := ntx64_odbc_cli.zip
# 	START_SCRIPT_NAME := run.bat
# else ifeq ($(GOOS),darwin)
# 	BINARY_NAME := $(APP_NAME)
# 	CLIDRIVER_NAME := macos64_odbc_cli.tar.gz
# 	START_SCRIPT_NAME := run.sh
# else ifeq ($(GOOS),linux)
# 	BINARY_NAME := $(APP_NAME)
# 	CLIDRIVER_NAME := linuxx64_odbc_cli.tar.gz
# 	START_SCRIPT_NAME := run.sh
# else
# 	$(error GOOS is not supported)
# endif

CLIDRIVER_URL := https://public.dhe.ibm.com/ibmdl/export/pub/software/data/db2/drivers/odbc_cli

export IBM_DB_HOME := ${CURDIR}/clidriver
export CGO_CFLAGS := -I${IBM_DB_HOME}/include
export CGO_LDFLAGS := -L${IBM_DB_HOME}/lib
ifeq ($(OS),darwin)
	export DYLD_LIBRARY_PATH := $(DYLD_LIBRARY_PATH):${IBM_DB_HOME}/lib
else ifeq ($(OS),linux)
	export LD_LIBRARY_PATH := $(LD_LIBRARY_PATH):${IBM_DB_HOME}/lib
endif
export PATH := $(PATH):${IBM_DB_HOME}/bin

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
	@if [ ! -d "$(CURDIR)/dist/${GOOS}_${GOARCH}/${APP_NAME}/clidriver" ]; then \
		rm -rf dist; \
	else \
		mkdir -p /tmp/${GOOS}_${GOARCH}/${APP_NAME}; \
		cp -r ./dist/${GOOS}_${GOARCH}/${APP_NAME}/clidriver /tmp/${GOOS}_${GOARCH}/${APP_NAME}/clidriver; \
		rm -rf dist; \
		mkdir -p dist/${GOOS}_${GOARCH}/${APP_NAME}; \
		cp -r /tmp/${GOOS}_${GOARCH}/${APP_NAME}/clidriver ./dist/${GOOS}_${GOARCH}/${APP_NAME}/clidriver; \
		rm -rf /tmp/${GOOS}_${GOARCH}; \
	fi

## go/version/sync: syncronyze go binary with the version specified in the Makefile
.PHONY: go/version/sync
go/version/sync:
	@if [ ! "${GO}" == "go" ]; then \
		echo "Syncing Go version..."; \
		go install golang.org/dl/${GO}@latest; \
		${GO} download; \
	fi

.PHONY: ibmdb
ibmdb:
	@if [ ! -d ${GO_IBM_DB_PATH} ]; then \
		mkdir -p ${GO_IBM_DB_PATH}; \
		echo -e "\nDownloading IBM DB2 CLI driver..."; \
		curl -o ${GO_IBM_DB_PATH}/${DEV_CLIDRIVER_NAME} ${CLIDRIVER_URL}/${DEV_CLIDRIVER_NAME}; \
		echo -e "\nExtracting IBM DB2 CLI driver..."; \
		tar -xvf ${GO_IBM_DB_PATH}/${DEV_CLIDRIVER_NAME} -C ${GO_IBM_DB_PATH}; \
		rm ${GO_IBM_DB_PATH}/${DEV_CLIDRIVER_NAME}; \
	fi

## ibmdb/latest: download latest version of IBM DB2 CLI driver
.PHONY: ibmdb/latest
ibmdb/latest:
	@echo "Downloading latest IBM DB2 CLI driver..."
	@rm -rf ${GO_IBM_DB_PATH}
	@mkdir -p ${GO_IBM_DB_PATH}
	@curl -o ${GO_IBM_DB_PATH}/${DEV_CLIDRIVER_NAME} ${CLIDRIVER_URL}/${DEV_CLIDRIVER_NAME}
	@echo -e "\nExtracting IBM DB2 CLI driver..."
	@tar -xvf ${GO_IBM_DB_PATH}/${DEV_CLIDRIVER_NAME} -C ${GO_IBM_DB_PATH}
	@rm ${GO_IBM_DB_PATH}/${DEV_CLIDRIVER_NAME}

## config: (Re)configure project variables and save to build.env
.PHONY: config
config:
	@echo -e "\nConfiguring build variables (press Enter to accept default):"
	
	@echo -e "\nGo binary that you want to use"
	@echo "Example: go1.21.10"
	@echo "To use the default version installed on your system, use \"go\" without any version number"
	@read -p "Enter Go binary [${GO}]: " go_val; \
	echo "GO := $${go_val:-${GO}}" > build.env

	@echo -e "\nThe absolute path of the go clidriver."
	@echo "Example: /home/user/Documents/go_ibm_db"
	@read -p "Enter clidriver path [${GO_IBM_DB_PATH}]: " clidriver_val; \
	echo "GO_IBM_DB_PATH := $${clidriver_val:-${GO_IBM_DB_PATH}}" > build.env

	@echo -e "\nLocal development OS."
	@echo "Accepted Values: darwin, linux"
	@read -p "Enter local development OS [${OS}]: " os_val; \
	echo "OS := $${os_val:-${OS}}" >> build.env

	@echo -e "\nLocal development architecture."
	@read -p "Enter local development ARCH (e.g., amd64, arm64) [${ARCH}]: " arch_val; \
	echo "ARCH := $${arch_val:-${ARCH}}" >> build.env

	@echo -e "\nGo main package (e.g., github.com/user/repo)."
	@read -p "Enter Go main package [${MAIN_PACKAGE}]: " main_pkg_val; \
	echo "MAIN_PACKAGE := $${main_pkg_val:-${MAIN_PACKAGE}}" >> build.env

	@echo -e "\nThe path to the folder where main.go resides."
	@echo "Example: ./cmd/my-app"
	@read -p "Enter path to main.go [${MAIN_PACKAGE_PATH}]: " main_path_val; \
	echo "MAIN_PACKAGE_PATH := $${main_path_val:-${MAIN_PACKAGE_PATH}}" >> build.env

	@echo -e "\nThe absolute path of the .arm certificate."
	@echo "Example: /home/user/Documents/TrustStore/etl.arm"
	@read -p "Enter path to .arm certificate [${CERTIFICATE_PATH}]: " cert_path_val; \
	echo "CERTIFICATE_PATH := $${cert_path_val:-${CERTIFICATE_PATH}}" >> build.env

	@echo -e "\nUse if the app requires flags (ex: -u username -p password)."
	@echo "Can be left blank, or can be overridden on the command line:"
	@echo "make run ARGS=\"-u user -p pass\""
	@read -p "Enter default run arguments [${ARGS}]: " args_val; \
	echo "ARGS := $${args_val:-${ARGS}}" >> build.env

	@echo -e "\nProduction build OS."
	@echo "Accepted Values: windows, darwin, linux"
	@read -p "Enter production build OS [${GOOS}]: " goos_val; \
	echo "GOOS := $${goos_val:-${GOOS}}" >> build.env

	@echo -e "\nProduction build architecture."
	@echo "Run \"go tool dist list\" for all possible values"
	@read -p "Enter production build ARCH (e.g., amd64, arm64) [${GOARCH}]: " goarch_val; \
	echo "GOARCH := $${goarch_val:-${GOARCH}}" >> build.env

	@echo -e "\nConfiguration saved to build.env"

## init: initialize the project
.PHONY: init
init: config ibmdb go/version/sync
	@if ! command -v "golangci-lint" &> /dev/null; then \
		echo "Please install 'golangci-lint' from https://golangci-lint.run/docs/welcome/install/ to continue."; \
		exit 1; \
	fi
	@echo -e "\nInitializing project..."
	@echo "Project name: ${APP_NAME}"
	@echo -e "\nIBM DB2 CLI driver info:"
	@echo "$$(${GO_IBM_DB_PATH}/clidriver/bin/db2level)"
	@echo -e "\nInitializing git repository..."
	@if [ ! -d .git ]; then git init; fi
	@touch .gitignore
	@grep -qxF "certs/" .gitignore || echo "certs/" >> .gitignore
	@grep -qxF "clidriver/" .gitignore || echo "clidriver/" >> .gitignore
	@grep -qxF "dist/" .gitignore || echo "dist/" >> .gitignore
	@grep -qxF ".idea/" .gitignore || echo ".idea/" >> .gitignore
	@grep -qxF ".vscode/" .gitignore || echo ".vscode/" >> .gitignore
	@grep -qxF "build.env" .gitignore || echo "build.env" >> .gitignore
	@echo -e "\nInitializing Go module..."
	@if [ ! -f go.mod ]; then ${GO} mod init ${MAIN_PACKAGE}; fi
	@${GO} get -d github.com/ibmdb/go_ibm_db
	@mkdir -p certs
	@cp ${CERTIFICATE_PATH} certs
	@mkdir -p ${MAIN_PACKAGE_PATH}
	@if [ ! -f "${MAIN_PACKAGE_PATH}/main.go" ]; then touch ${MAIN_PACKAGE_PATH}/main.go; fi
	@echo -e "\nDownloading golangci-lint config..."
	@curl -O https://gist.githubusercontent.com/maratori/47a4d00457a92aa426dbd48a18776322/raw/ae78780d0653027c1c83d3a705cfda028afc1a5b/.golangci.yml
	@echo -e "\nDone."

# ==================================================================================== #
# QUALITY CONTROL
# ==================================================================================== #

## lint: run golangci-lint
.PHONY: lint
lint:
	@golangci-lint run

## tidy: format code and tidy modfile
.PHONY: tidy
tidy:
	${GO} fmt ./...
	${GO} mod tidy -v

## audit: run quality control checks
.PHONY: audit
audit:
	${GO} mod verify
	${GO} vet ./...
	${GO} run honnef.co/go/tools/cmd/staticcheck@latest -checks=all,-ST1000,-U1000 ./...
	${GO} run golang.org/x/vuln/cmd/govulncheck@latest ./...
	${GO} test -race -buildvcs -vet=off ./...

# ==================================================================================== #
# DEVELOPMENT
# ==================================================================================== #

## test: run all tests
.PHONY: test
test:
	${GO} test -v -race -buildvcs ./...

## test/integration: run all tests including integration
.PHONY: test/integration
test/integration:
	# include integration tests steps here...

## test/cover: run all tests and display coverage
.PHONY: test/cover
test/cover:
	${GO} test -v -race -buildvcs -coverprofile=/tmp/coverage.out ./...
	${GO} tool cover -html=/tmp/coverage.out

## build: build the application
# include additional build steps, like TypeScript, SCSS or Tailwind compilation here...
.PHONY: build
build: ibmdb
	@${GO} build -o /tmp/bin/${DEV_BINARY_NAME} ${MAIN_PACKAGE_PATH}

## run: run the  application
.PHONY: run
run: lint build
	@/tmp/bin/${DEV_BINARY_NAME} ${ARGS}

## run/no-lint: run the  application without linting
.PHONY: run/no-lint
run/no-lint: build
	@/tmp/bin/${DEV_BINARY_NAME} ${ARGS}

## watch: run the application with reloading on file changes
.PHONY: watch
watch: lint
	@${GO} run github.com/cosmtrek/air@latest \
		--build.cmd "make build" --build.bin "/tmp/bin/${DEV_BINARY_NAME} ${ARGS}" --build.delay "100" \
		--build.exclude_dir "certs,clidriver,dist" \
		--build.include_ext "go, tpl, tmpl, html, css, scss, js, ts, sql, jpeg, jpg, gif, png, bmp, svg, webp, ico" \
		--misc.clean_on_exit "true"

# ==================================================================================== #
# OPERATIONS
# ==================================================================================== #

## push: push changes to the remote Git repository
.PHONY: push
push: lint tidy audit no-dirty
	git push

## prod: create a production build of the application
.PHONY: prod
prod: clean lint tidy audit no-dirty
	GOOS=${GOOS} GOARCH=${GOARCH} ${GO} build -ldflags='-s' -o dist/${GOOS}_${GOARCH}/${APP_NAME}/${BINARY_NAME} ${MAIN_PACKAGE_PATH}
	upx -5 ./dist/${GOOS}_${GOARCH}/${APP_NAME}/${BINARY_NAME}
	@echo -e "\nCopying certificates..."
	@cp -r ./certs ./dist/${GOOS}_${GOARCH}/${APP_NAME}/
	
	@if [ ! -d "$(CURDIR)/dist/${GOOS}_${GOARCH}/${APP_NAME}/clidriver" ]; then \
		if [ "${OS}" == "${GOOS}" ]; then \
			echo -e "\nCreating clidriver for production..."; \
			cp -r ${GO_IBM_DB_PATH} ./dist/${GOOS}_${GOARCH}/${APP_NAME}/; \
		else \
			echo -e "\nDownloading IBM DB2 CLI driver..."; \
			cd dist/${GOOS}_${GOARCH}/${APP_NAME}; \
			curl -O ${CLIDRIVER_URL}/${CLIDRIVER_NAME}; \
			echo -e "\nExtracting IBM DB2 CLI driver..."; \
			if [ "${GOOS}" == "windows" ]; then \
				unzip ${CLIDRIVER_NAME}; \
			else \
				tar -xvf ${CLIDRIVER_NAME}; \
			fi; \
			rm ${CLIDRIVER_NAME}; \
		fi; \
	fi

	@echo -e "\nCreating run script..."
	@if [ "${GOOS}" == "windows" ]; then \
		echo "@echo off" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
		echo "cd clidriver" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
		echo "set clidrvpath=%cd%" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
		echo "set IBM_DB_HOME=%clidrvpath%" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
		echo "set PATH=%PATH%;%IBM_DB_HOME%\bin" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
		echo "set PATH=%PATH%;%clidrvpath%\bin\amd64.VC12.CRT" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
		echo "cd ../" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
		echo "cmd /k ${BINARY_NAME}" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
	else \
		echo "if [ \"\$$IBM_DB_HOME\" == \"\" ]" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
		echo "then" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
		echo "    IBM_DB_HOME=\`pwd\`/clidriver" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
		echo "fi" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
		echo "" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
		echo "OS=\`uname\`" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
		echo "" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
		echo "export CGO_CFLAGS=-I\$$IBM_DB_HOME/include" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
		echo "export CGO_LDFLAGS=-L\$$IBM_DB_HOME/lib" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
		echo "" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
		echo "if [ \"\$$OS\" == \"Darwin\" ]" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
		echo "then" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
		echo "    export DYLD_LIBRARY_PATH=\$$DYLD_LIBRARY_PATH:\$$IBM_DB_HOME/lib" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
		echo "else" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
		echo "    export LD_LIBRARY_PATH=\$$LD_LIBRARY_PATH:\$$IBM_DB_HOME/lib" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
		echo "fi" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
		echo "" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
		echo "export PATH=\$$PATH:\$$IBM_DB_HOME/bin" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
		echo "" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
		echo "./${BINARY_NAME}" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
		echo "" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
		echo "echo -e \"\\n\"" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
		echo "read -rp \"Press any key to continue\"" >> dist/${GOOS}_${GOARCH}/${APP_NAME}/${START_SCRIPT_NAME}; \
	fi
	@echo -e "\nDone."

## deploy: deploy the application to production
.PHONY: deploy
deploy:
	# include deployment steps here...

