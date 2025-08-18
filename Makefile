help:
	@echo "Pour lancer: make up"

up:
	@docker compose up -d
	@docker exec -it vapor-app /bin/bash