package main

import (
	"fmt"
)

type wallase struct {
}

func newWallase() *wallase {
	return new(wallase)
}

func (w *wallase) index(c crawl) {
	fmt.Println(c)
}
