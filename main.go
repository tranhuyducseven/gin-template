package main

import (
	"database/sql"
	"log"
	"os"

	"github.com/golang-migrate/migrate/v4"
	"github.com/golang-migrate/migrate/v4/database"
	"github.com/golang-migrate/migrate/v4/database/postgres"
	"github.com/golang-migrate/migrate/v4/database/sqlite3"
	"github.com/golang-migrate/migrate/v4/source/file"
	_ "github.com/lib/pq"
	_ "github.com/mattn/go-sqlite3"
	"github.com/tranhuyducseven/GinTemplate/api"
	db "github.com/tranhuyducseven/GinTemplate/db/sqlc"
	"github.com/tranhuyducseven/GinTemplate/util"
)



func main() {

	config, err := util.LoadConfig(".")
	if err != nil {
		log.Fatal("cannot load config:", err)
	}
	args := os.Args

	driverName := config.DBPostgresDriver
	dataSourceName := config.DBPostgresSource
	migrationURL := config.MigrationPostgresUrl
	
	if len(args) > 1 && args[1] == "sqlite3" {
		driverName = config.DBSqlite3Driver
		dataSourceName = config.DBSqlite3Source
		migrationURL = config.MigrationSqlite3Url
	}
	
	conn, err := sql.Open(driverName, dataSourceName)

	if err != nil {
		log.Fatal("cannot connect to the db...:", err)
	}

	defer conn.Close()

	runDBMigration(migrationURL, dataSourceName, driverName, conn, config.NumberOfMigrationFiles)
	
	
	store := db.NewStore(conn)

	server, err := api.NewServer(config, store)

	if err != nil {
		log.Fatal("cannot initialize the server...", err)
	}

	err = server.Start(config.ServerAddress)

	if err != nil {
		log.Fatal("cannot connect to the server...", err)
	}
}


func runDBMigration(migrationURL string, dbSource string, dbDriver string, conn *sql.DB, numOfMigrationFiles uint) {
	
	var instance database.Driver
	var err error
	if dbDriver == "postgres"{
		instance, err = postgres.WithInstance(conn, &postgres.Config{})
		if err != nil {
			log.Fatal(err)
		}
	}	else if dbDriver == "sqlite3"{
		instance, err = sqlite3.WithInstance(conn, &sqlite3.Config{})
		if err != nil {
			log.Fatal(err)
		}
	}
	
	fSrc, err := (&file.File{}).Open(migrationURL)
	if err != nil {
		log.Fatal(err)
	}


	m, err := migrate.NewWithInstance("file", fSrc, dbDriver, instance)
	if err != nil {
		log.Fatal(err)
	}

	 // Check which migrations have already been applied
	 // Check which migrations have already been applied
	latestVersion, dirty, err := m.Version()
	if err != nil {
		if err == migrate.ErrNilVersion {
			// If the migration table does not exist, create it
			latestVersion = 0
		} else {
			log.Fatal(err)
		}
	}

 
	if dirty {
		 log.Fatal("database is dirty, please fix it first")
	 }
 
	 // Apply only the migrations that haven't been applied yet
	 if latestVersion < numOfMigrationFiles {
		 if err := m.Up(); err != nil {
			 log.Fatal(err)
		 }
	 }


}
