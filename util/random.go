package util

import (
	"database/sql"
	"fmt"
	"math/rand"
	"strings"
	"time"
)

func init() {
	rand.Seed(time.Now().UnixNano())
}

func RandomInt(min, max int64) int64 {
	return min + rand.Int63n(max-min+1)
}

const alphabet = "abcdefghijklmnopqrstuvwxyz"
const number = "0123456789"

func RandomString(n int) string {
	var sb strings.Builder
	k := len(alphabet)

	for i := 0; i < n; i++ {
		c := alphabet[rand.Intn(k)]
		sb.WriteByte(c)
	}

	return sb.String()
}
func RandomOwner() string {
	return RandomString(6)
}
func RandomMoney() int64 {
	return RandomInt(0, 1000)
}
func RandomCurrency() string {
	currencies := []string{"USD", "EUR", "GBP"}
	n := len(currencies)
	return currencies[rand.Intn(n)]
}

// RandomEmail generates a random email
func RandomEmail() string {
	return fmt.Sprintf("%s@email.com", RandomString(6))
}

func RandomNorDate() time.Time {
	min := time.Date(1970, 1, 0, 0, 0, 0, 0, time.UTC).Unix()
	max := time.Date(2070, 1, 0, 0, 0, 0, 0, time.UTC).Unix()
	delta := max - min
	sec := rand.Int63n(delta) + min
	return time.Unix(sec, 0)
}
func RandomNullDate() sql.NullTime {
	return sql.NullTime{
		Time:  RandomNorDate(),
		Valid: true,
	}
}

func RandomGender() string {
	genders := []string{"male", "female"}
	n := len(genders)
	return genders[rand.Intn(n)]
}

func RandomPhone() string {
	var sb strings.Builder
	k := len(number)

	for i := 0; i < 10; i++ {
		c := number[rand.Intn(k)]
		sb.WriteByte(c)
	}
	return sb.String()
}

func RandomRole() string {
	roles := []string{"manager", "staff", "user"}
	n := len(roles)
	return roles[rand.Intn(n)]
}
