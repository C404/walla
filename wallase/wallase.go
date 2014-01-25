package main

import (
	"github.com/mattbaird/elastigo/core"
	"net/http"
)

const (
	esIndex = "axa.fr"
	esType  = "axa_document"
)

type wallase struct{}

func (w *wallase) index(d axaDocument) (int, string) {
	id := hashUrl(d.Url)

	resp, err := core.Index(false, esIndex, esType, id, d)
	if err != nil {
		panic(err)
	}
	if resp.Exists {
		return http.StatusNotModified, ""
	}
	return http.StatusCreated, ""
}
