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
	docker build . -t core_banking
docker.run:
	docker run -i --rm --name core_banking -p 8080:8080 -t core_banking