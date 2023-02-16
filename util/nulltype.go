package util

import (
	"database/sql"
	"time"
)

func NullInt64(value int64) sql.NullInt64 {
	return sql.NullInt64{
		Int64: value,
		Valid: value != 0,
	}

}

func MapStringToNullString(data string) sql.NullString {

	var result = sql.NullString{
		String: data,
		Valid:  false,
	}
	if data != "" {
		result.Valid = true
	}
	return result
}

func MapStringToNullTime(data string) (sql.NullTime, error) {

	var parseData, err = time.Parse(LayoutDate, data)
	if err != nil {
		return sql.NullTime{Time: time.Now(), Valid: false}, err
	}
	var result = sql.NullTime{
		Time:  parseData,
		Valid: false,
	}
	if data != "" {
		result.Valid = true
	}
	return result, err

}
