package util

import (
	"errors"
	"fmt"
	"os"
	"time"

	"github.com/joho/godotenv"
)
type Config struct {
	DBDriver            string        `mapstructure:"DB_DRIVER"`
	DBSource            string        `mapstructure:"DB_SOURCE"`
	MigrationUrl        string        `mapstructure:"MIGRATION_URL"`
	ServerAddress       string        `mapstructure:"SERVER_ADDRESS"`
	TokenSymmetricKey   string        `mapstructure:"TOKEN_SYMMETRIC_KEY"`
	AccessTokenDuration time.Duration `mapstructure:"ACCESS_TOKEN_DURATION"`
}

func LoadConfig(path string) (config *Config, err error) {
	// load env
	env := os.Getenv("APP_ENV")
	// Default to development if not set
	if "" == env {
		env = "development"
	}
	fmt.Println("\nWelcome to " + env + " environment!\n")
	
	godotenv.Load(".env." + env + ".local")
	if "test" != env {
		godotenv.Load(".env.local")
	}
	godotenv.Load(".env." + env)
	godotenv.Load() // The Original .env

	dbDriver := os.Getenv("DB_DRIVER")
	dbSource := os.Getenv("DB_SOURCE")
	migrationUrl := os.Getenv("MIGRATION_URL")
	serverAddress := os.Getenv("SERVER_ADDRESS")
	tokenSymmetricKey := os.Getenv("TOKEN_SYMMETRIC_KEY")
	accessTokenDuration := os.Getenv("ACCESS_TOKEN_DURATION")
	if dbDriver == "" {
		dbDriver = "postgres"
	}
	if dbSource == "" {
		dbSource = "postgresql://root:secret@localhost:5432/sampledb?sslmode=disable"
	}
	if migrationUrl == "" {
		migrationUrl = "file://db/migration"
	}
	if serverAddress == "" {
		serverAddress = "0.0.0.0:8000"
	}
	if tokenSymmetricKey == "" {
		return nil, errors.New("token symmetric key is not set")
	}
	if accessTokenDuration == "" {
		return nil, errors.New("access token duration is not set")
	}

	duration, err := time.ParseDuration(accessTokenDuration)
	if err != nil {
		return nil, err
	}
	return &Config{
		DBDriver:            dbDriver,
		DBSource:            dbSource,
		MigrationUrl:        migrationUrl,
		ServerAddress:       serverAddress,
		TokenSymmetricKey:   tokenSymmetricKey,
		AccessTokenDuration: duration,
	}, nil

}
