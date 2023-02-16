package token

import (
	"encoding/json"
	"fmt"
	"testing"
	"time"

	"github.com/stretchr/testify/require"
	"github.com/tranhuyducseven/GinTemplate/util"
)

func TestPasetoMaker(t *testing.T) {
	maker, err := NewPasetoMaker(util.RandomString(32))
	require.NoError(t, err)

	userinfo := createRandomUserInfo()
	//	meta_data := MetaData(&userinfo)
	duration := time.Minute
	issuedAt := time.Now()
	expiredAt := issuedAt.Add(duration)
	token, err := maker.CreateToken(userinfo.Username, duration)
	require.NoError(t, err)
	require.NotEmpty(t, token)
	payload, err := maker.VerifyToken(token)
	require.NoError(t, err)
	require.NotEmpty(t, token)

	require.NotZero(t, payload.ID)

	// Get metadatapayload
	b, err := json.Marshal(payload.Username)
	require.NoError(t, err)
	var userdata string
	err = json.Unmarshal(b, &userdata)
	require.NoError(t, err)
	fmt.Println(">>>", userdata)
	fmt.Println(">>>", userinfo.Username)

	require.Equal(t, userinfo.Username, userdata)
	require.WithinDuration(t, issuedAt, payload.IssuedAt, time.Second)
	require.WithinDuration(t, expiredAt, payload.ExpiredAt, time.Second)
}
func createRandomUserInfo() UserInfo {
	return UserInfo{
		Username: util.RandomOwner(),
		Role:     util.RandomRole(),
	}
}
func TestExpiredPasetoToken(t *testing.T) {
	maker, err := NewPasetoMaker(util.RandomString(32))
	require.NoError(t, err)

	token, err := maker.CreateToken(createRandomUserInfo().Username, -time.Minute)
	require.NoError(t, err)
	require.NotEmpty(t, token)

	payload, err := maker.VerifyToken(token)
	require.Error(t, err)
	require.EqualError(t, err, ErrExpiredToken.Error())
	require.Nil(t, payload)
}
