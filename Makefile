
# Run this command once when init project
bootstrap:
	docker-compose -f docker-compose.dev.yml up -d --build;
# For development
downstrap:
	docker-compose -f docker-compose.dev.yml down

clean_dev:
	docker-compose -f docker-compose.dev.yml down --volumes --remove-orphans --rmi local

update:
	make clean_dev
	make bootstrap

# For db
	
createdb:
	docker exec -it postgres createdb --username=root --owner=root sampledb 
dropdb:
	docker exec -it postgres dropdb sampledb 

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/sampledb?sslmode=disable" -verbose up
migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/sampledb?sslmode=disable" -verbose down

# Followings commands 're used for making seed data

copy_sql:
	cat db/initdb/*.sql db/initdb/func_proc/*.sql db/initdb/trigger/*.sql >> db/initdb/init.sql
remove_sql:
	rm db/initdb/init.sql
init_sql:
	docker exec -it postgres psql -U root sampledb -a -f sampledb/initdb/init.sql
seed:
	make copy_sql && make init_sql && make remove_sql

# This command is used for Postgres interaction

psql:
	docker exec -it postgres psql -U root -d sampledb 

test:
	go test -v -cover ./...

# Run server in development
server:
	go run main.go

sqlc:
	sqlc generate

# mock database
mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/tranhuyducseven/GinTemplate/db/sqlc Store


.PHONY: bootstrap downstrap clean_dev update createdb dropdb migrateup migratedown copy_sql remove_sql init_sql seed psql test server sqlc mock