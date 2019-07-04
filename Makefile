APP_NAME ?= `grep 'app:' mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/app://' -e 's/[:,]//g'`
APP_VSN ?= `grep 'version:' mix.exs | cut -d '"' -f2`
BUILD ?= `git rev-parse --short HEAD`

build:
	mix do deps.get, compile
run:
	mix run --no-halt
start:
	make build
	make run
ci:
	make build
	mix format --check-formatted
	mix credo --strict
	mix test
test:
	mix test
docker.start:
	make docker.build
	make docker.run
docker.build:
	docker build -t $(APP_NAME):$(APP_VSN)-$(BUILD) -t $(APP_NAME):latest .
docker.run:
	docker run --expose 4000 -p 4000:4000 --rm -it core_banking:latest