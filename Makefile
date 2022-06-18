
all:
	@echo "Use commands like 'build', 'run', 'test', etc."
	swift build

run:
	swift run

test:
	swift test

dockerrun:
	docker-compose up --build
