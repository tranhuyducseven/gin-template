package util

import (
	"time"

	"github.com/spf13/viper"
)

type Config struct {
	DBPostgresDriver            string        	`mapstructure:"DB_POSTGRES_DRIVER"`
	DBPostgresSource            string        	`mapstructure:"DB_POSTGRES_SOURCE"`
	MigrationPostgresUrl 		string 			`mapstructure:"MIGRATION_POSTGRES_URL"`
	DBSqlite3Driver            	string        	`mapstructure:"DB_SQLITE3_DRIVER"`
	DBSqlite3Source            	string        	`mapstructure:"DB_SQLITE3_SOURCE"`
	MigrationSqlite3Url 		string 			`mapstructure:"MIGRATION_SQLITE3_URL"`
	ServerAddress      			string        	`mapstructure:"SERVER_ADDRESS"`
	TokenSymmetricKey   		string        	`mapstructure:"TOKEN_SYMMETRIC_KEY"`
	AccessTokenDuration 		time.Duration 	`mapstructure:"ACCESS_TOKEN_DURATION"`
	NumberOfMigrationFiles 		uint 			`mapstructure:"NUMBER_OF_MIGRATION_FILES"`
}

func LoadConfig(path string) (config Config, err error) {
	viper.AddConfigPath(path)
	viper.SetConfigName("app")
	viper.SetConfigType("env")

	viper.AutomaticEnv()

	err = viper.ReadInConfig()
	if err != nil {
		return
	}
	err = viper.Unmarshal(&config)
	return
}
