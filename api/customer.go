package api

import (
	"database/sql"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/lib/pq"
	db "github.com/tranhuyducseven/GinTemplate/db/sqlc"
	"github.com/tranhuyducseven/GinTemplate/util"
)

type createCustomerRequest struct {
	Username string `json:"username" binding:"required,alphanum"`
	Password string `json:"password" binding:"required,min=6"`
	Fname    string `json:"fname" binding:"required"`
	Lname    string `json:"lname" binding:"required"`
	Sex      string `json:"sex"`
	Dob      string `json:"dob"`
	Phone    string `json:"phone"`
	Email    string `json:"email"`
}

type customerResponse struct {
	Username          string    `json:"username"`
	Fname             string    `json:"fname"`
	Lname             string    `json:"lname"`
	Sex               string    `json:"sex"`
	Dob               time.Time    `json:"dob"`
	Phone             string    `json:"phone"`
	Email             string    `json:"email"`
	PasswordChangedAt time.Time `json:"password_changed_at"`
	CreatedAt         time.Time `json:"created_at"`
}

func newCustomerResponse(customer db.Customer) customerResponse {
	return customerResponse{
		Username:          customer.Username,
		Fname:             customer.Fname,
		Lname:             customer.Lname,
		Sex:               customer.Sex.String,
		Dob:               customer.Dob.Time,
		Phone:             customer.Phone.String,
		Email:             customer.Email.String,
		PasswordChangedAt: customer.PasswordChangedAt,
		CreatedAt:         customer.CreatedAt,
	}
}

func (server *Server) createCustomer(ctx *gin.Context) {
	var req createCustomerRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	hashedPassword, err := util.HashPassword(req.Password)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}
	time, err := util.MapStringToNullTime(req.Dob)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}
	arg := db.CreateCustomerParams{
		Username:       req.Username,
		HashedPassword: hashedPassword,
		Fname:          req.Fname,
		Lname:          req.Lname,
		Sex:            util.MapStringToNullString(req.Sex),
		Dob:            time,
		Phone:          util.MapStringToNullString(req.Phone),
		Email:          util.MapStringToNullString(req.Email),
	}

	customer, err := server.store.CreateCustomer(ctx, arg)
	if err != nil {
		if pqErr, ok := err.(*pq.Error); ok {
			switch pqErr.Code.Name() {
			case "unique_violation":
				ctx.JSON(http.StatusForbidden, errorResponse(err))
				return
			}
		}
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	rsp := newCustomerResponse(customer)
	ctx.JSON(http.StatusOK, rsp)
}

// Login
type loginCustomerRequest struct {
	Username string `json:"username" binding:"required,alphanum"`
	Password string `json:"password" binding:"required,min=6"`
}

type loginCustomerResponse struct {
	AccessToken string           `json:"access_token"`
	Customer    customerResponse `json:"user"`
}

func (server *Server) loginCustomer(ctx *gin.Context) {
	var req loginCustomerRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}
	customer, err := server.store.GetCustomer(ctx, req.Username)
	if err != nil {
		if err == sql.ErrNoRows {
			ctx.JSON(http.StatusNotFound, errorResponse(err))
			return
		}
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}
	err = util.CheckPassword(req.Password, customer.HashedPassword)
	if err != nil {
		ctx.JSON(http.StatusUnauthorized, errorResponse(err))
		return
	}

	accessToken, err := server.tokenMaker.CreateToken(
		customer.Username,
		server.config.AccessTokenDuration,
	)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}
	rsp := loginCustomerResponse{
		AccessToken: accessToken,
		Customer:    newCustomerResponse(customer),
	}
	ctx.JSON(http.StatusOK, rsp)
}

// Get Customer

type getCustomerRequest struct {
	Username string `uri:"username" binding:"required,min=1"`
}

func (server *Server) getCustomer(ctx *gin.Context) {
	var req getCustomerRequest
	//========SHOULD BIND URI===========
	if err := ctx.ShouldBindUri(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}
	customer, err := server.store.GetCustomer(ctx, req.Username)

	if err != nil {
		if err == sql.ErrNoRows {
			ctx.JSON(http.StatusNotFound, errorResponse(err))
			return
		}
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	ctx.JSON(http.StatusOK, newCustomerResponse(customer))
}

// List Customer

type listCustomerRequest struct {
	PageID   int32 `form:"page_id" binding:"required,min=1"`
	PageSize int32 `form:"page_size" binding:"required,min=5,max=10"`
}

func (server *Server) listCustomers(ctx *gin.Context) {
	var req listCustomerRequest
	if err := ctx.ShouldBindQuery(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}
	arg := db.ListCustomersParams{
		Limit:  req.PageSize,
		Offset: (req.PageID - 1) * req.PageSize,
	}
	customers, err := server.store.ListCustomers(ctx, arg)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	rsp := make([]customerResponse, req.PageSize)
	for index, value := range customers {
		rsp[index] = newCustomerResponse(value)
	}
	ctx.JSON(http.StatusOK, rsp)

}

//

//DELETE

type deleteCustomerRequest struct {
	Username string `form:"d_username" binding:"required,min=1"`
}

func (server *Server) deleteCustomer(ctx *gin.Context) {
	var req deleteCustomerRequest
	if err := ctx.ShouldBindQuery(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}
	err := server.store.DeleteCustomer(ctx, req.Username)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}
	ctx.JSON(http.StatusOK, req.Username)
}

type updateInfoCustomerRequest struct {
	Username string `json:"username" binding:"required,alphanum"`
	Sex      string `json:"sex"`
	Dob      string `json:"dob"`
	Phone    string `json:"phone"`
	Email    string `json:"email"`
}

func (server *Server) updateInfoCustomer(ctx *gin.Context) {
	var req updateInfoCustomerRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}
	time, err := util.MapStringToNullTime(req.Dob)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	arg := db.UpdateInfoCustomerParams{
		Username: req.Username,
		Sex:      util.MapStringToNullString(req.Sex),
		Dob:      time,
		Phone:    util.MapStringToNullString(req.Phone),
		Email:    util.MapStringToNullString(req.Email),
	}

	customer, err := server.store.UpdateInfoCustomer(ctx, arg)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	rsp := newCustomerResponse(customer)
	ctx.JSON(http.StatusOK, rsp)

}

type updatePasswordCustomerRequest struct {
	Username string `json:"username" binding:"required,alphanum"`
	Password string `json:"password"`
}

func (server *Server) updatePasswordCustomer(ctx *gin.Context) {
	var req updatePasswordCustomerRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}
	hashedPassword, err := util.HashPassword(req.Password)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	arg := db.UpdatePasswordCustomerParams{
		Username:          req.Username,
		HashedPassword:    hashedPassword,
		PasswordChangedAt: time.Now(),
	}

	customer, err := server.store.UpdatePasswordCustomer(ctx, arg)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}

	rsp := newCustomerResponse(customer)
	ctx.JSON(http.StatusOK, rsp)

}
