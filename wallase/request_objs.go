package main

import (
	"github.com/codegangsta/martini-contrib/binding"
	"net/http"
)

type crawl struct {
	Url   string   `required json:"url"`
	Title string   `required json:"title"`
	Body  string   `required json:body"`
	Alts  []string `required json:alts"`
}

func (c *crawl) Validate(errors *binding.Errors, req *http.Request) {
}
