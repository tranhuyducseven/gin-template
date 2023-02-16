package util

import "time"

const LayoutDate = "2006-01-02"

func IsDateString(date string) bool {
	_, err := time.Parse(LayoutDate, date)
	return err == nil
}
