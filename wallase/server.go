package main

import (
	"github.com/codegangsta/martini"
	"github.com/codegangsta/martini-contrib/binding"
	"github.com/codegangsta/martini-contrib/gzip"
)

func main() {
	m := martini.New()

	m.Use(gzip.All())
	m.Use(martini.Recovery())
	m.Use(martini.Logger())

	w := newWallase()
	r := martini.NewRouter()

	r.Post("/crawl", binding.Bind(crawl{}), w.index)

	m.Action(r.Handle)
	m.Run()
}
