COMPOSE = docker compose

# Сборка контейнеров
build:
	$(COMPOSE) build

# Подготовка базы данных
db-setup:
	$(COMPOSE) up -d db
	$(COMPOSE) run app bundle exec hanami db create
	$(COMPOSE) run app bundle exec hanami db migrate

# Запуск приложения
start:
	$(COMPOSE) up -d

# Полный процесс: сборка, настройка БД и запуск
setup: build db-setup start

# Остановка контейнеров
stop:
	$(COMPOSE) down

# Удаление контейнеров, образов и данных
clean:
	$(COMPOSE) down --volumes --rmi all

# Логи приложения
logs:
	$(COMPOSE) logs -f app
