install:
	go mod tidy
bootstrap:
	docker-compose -f docker-compose.dev.yml up -d --build --remove-orphans;
downstrap:
	docker-compose -f docker-compose.dev.yml down --remove-orphans --volumes
clean_dev:
	docker-compose -f docker-compose.dev.yml down --volumes --remove-orphans --rmi local
update:
	make clean_dev
	make bootstrap
createdb:
	docker exec -it postgres createdb --username=root --owner=root sampledb 
dropdb:
	docker exec -it postgres dropdb sampledb 

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/sampledb?sslmode=disable" -verbose up
migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/sampledb?sslmode=disable" -verbose down
psql:
	docker exec -it postgres psql -U root -d sampledb 
test:
	go test -v -cover -race ./...
sqlc:
	sqlc generate
mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/tranhuyducseven/GinTemplate/db/sqlc Store
server: 
	go run main.go
run-prod:
	APP_ENV=production go run main.go

all:
	make bootstrap
	make sqlc
	make mock
	make server

.PHONY: bootstrap downstrap clean_dev update createdb dropdb migrateup migratedown  psql test sqlc mock server all