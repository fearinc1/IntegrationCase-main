PROJECT_NAME=Integration
CONFIGURATION=Release
OUTPUT_DIR=bin/$(CONFIGURATION)

.PHONY: all
all: build

.PHONY: clean
clean:
	@echo "Cleaning project..."
	dotnet clean $(PROJECT_NAME)

.PHONY: restore
restore:
	@echo "Restoring dependencies..."
	dotnet restore $(PROJECT_NAME)

.PHONY: build
build: restore
	@echo "Building project..."
	dotnet build $(PROJECT_NAME) --configuration $(CONFIGURATION)

.PHONY: run
run: build
	@echo "Running project..."
	dotnet run --project $(PROJECT_NAME) --configuration $(CONFIGURATION)

.PHONY: test
test:
	@echo "Running tests..."
	dotnet test $(PROJECT_NAME)

.PHONY: publish
publish: build
	@echo "Publishing project..."
	dotnet publish $(PROJECT_NAME) --configuration $(CONFIGURATION) --output $(OUTPUT_DIR)

.PHONY: watch
watch:
	@echo "Watching project..."
	dotnet watch run --project $(PROJECT_NAME)

.PHONY: help
help:
	@echo "Available targets:"
	@echo "  make          - Build the project (default)"
	@echo "  make clean    - Clean the project"
	@echo "  make restore  - Restore project dependencies"
	@echo "  make build    - Build the project"
	@echo "  make run      - Build and run the project"
	@echo "  make test     - Run unit tests"
	@echo "  make publish  - Publish the project to the output directory"
	@echo "  make watch    - Watch for changes and run the project"
