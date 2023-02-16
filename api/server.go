package api

import (
	"fmt"

	"github.com/gin-gonic/gin"
	db "github.com/tranhuyducseven/GinTemplate/db/sqlc"
	"github.com/tranhuyducseven/GinTemplate/token"
	"github.com/tranhuyducseven/GinTemplate/util"
)

type Server struct {
	config     util.Config
	store      db.Store
	tokenMaker token.Maker
	router     *gin.Engine
}

func NewServer(config util.Config, store db.Store) (*Server, error) {
	tokenMaker, err := token.NewPasetoMaker(config.TokenSymmetricKey)
	if err != nil {
		return nil, fmt.Errorf("cannot create token maker: %w", err)
	}

	server := &Server{
		store:      store,
		config:     config,
		tokenMaker: tokenMaker,
	}
	server.setupRouter()
	return server, nil
}

func errorResponse(err error) gin.H {
	return gin.H{"error": err.Error()}
}

func (server *Server) Start(address string) error {
	return server.router.Run(address)
}

func (server *Server) setupRouter() {
	router := gin.Default()
	router.Use(CORSMiddleware())
	server.setupGinCustomerValidation()

	authRoutes := router.Group("/").Use(authMiddleware(server.tokenMaker))
	authRoutes.POST("/api/customer/create", server.createCustomer)
	authRoutes.POST("/api/customer/login", server.loginCustomer)
	authRoutes.GET("/api/customer/:username", server.getCustomer)
	authRoutes.GET("/api/customers", server.listCustomers)
	authRoutes.DELETE("/api/customer", server.deleteCustomer)
	authRoutes.PATCH("/api/customer/info", server.updateInfoCustomer)
	authRoutes.PATCH("/api/customer/password", server.updatePasswordCustomer)
	server.router = router
}


