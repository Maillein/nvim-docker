build:
	docker compose build

up:
	docker compose up -d

down:
	docker compose down

n: up
	docker exec -it neovim /bin/bash

cp:
	docker cp neovim:/root/.config/nvim ./config/

clean:
	rm -rf cache mason parser
