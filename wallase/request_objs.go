package main

type axaDocument struct {
	Url   string   `json:"url"`
	Title string   `json:"title"`
	Body  string   `json:"body"`
	Alts  []string `json:"alts"`
}
