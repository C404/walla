package main

import (
	"github.com/codegangsta/martini"
	"github.com/codegangsta/martini-contrib/binding"
	"github.com/codegangsta/martini-contrib/gzip"
	"github.com/mattbaird/elastigo/api"
)

func main() {
	api.Domain = "localhost"
	// api.Port = "9300"

	m := martini.New()

	m.Use(gzip.All())
	m.Use(martini.Recovery())
	m.Use(martini.Logger())

	w := new(wallase)
	r := martini.NewRouter()

	r.Post("/crawl", binding.Bind(axaDocument{}), w.index)

	m.Action(r.Handle)
	m.Run()
}
