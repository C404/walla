package main

type axaDocument struct {
	Url   string   `json:"url"`
	Title string   `json:"title"`
	Body  string   `json:"body"`
	Alts  []string `json:"alts"`
}

type question struct {
	User    string `json:"user"`
	Message string `json:"message"`
}
