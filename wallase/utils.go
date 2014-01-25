package main

import (
	"github.com/tonnerre/golang-nzaat"
	"strconv"
)

func hashUrl(url string) string {
	hash := nzaat.New()
	hash.Write([]byte(url))

	return strconv.FormatUint(uint64(hash.Sum32()), 10)
}
