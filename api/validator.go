package api

import (
	"github.com/gin-gonic/gin/binding"
	"github.com/go-playground/validator/v10"
	"github.com/tranhuyducseven/GinTemplate/util"

)

var validDate validator.Func = func(fieldLevel validator.FieldLevel) bool {
	if date, ok := fieldLevel.Field().Interface().(string); ok {
		return util.IsDateString(date)
	}
	return false
}

func (server *Server) setupGinCustomerValidation() {
	if v, ok := binding.Validator.Engine().(*validator.Validate); ok {
		v.RegisterValidation("date", validDate)
	}
}