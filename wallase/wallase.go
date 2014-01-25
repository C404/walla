package main

import (
	"encoding/json"
	"fmt"
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

func (w *wallase) search(q question) (int, string) {
	var doc axaDocument

	query := fmt.Sprintf(`{
		"query": {
			"flt": {
				"fields": ["title", "body"],
				"like_text": "%s",
				"min_similarity" : 0.0,
				"ignore_tf" : true,
				"boost" : 1.0
			}
		}
	}`, q.Message)

	out, err := core.SearchRequest(false, esIndex, esType, query, "", 0)
	if err != nil {
		panic(err)
	}

	if len(out.Hits.Hits) >= 1 {
		for i := 0; i < len(out.Hits.Hits); i++ {
			if err := json.Unmarshal(out.Hits.Hits[i].Source, &doc); err != nil {
				panic(err)
			}
			println(doc.Title)
		}
	}
	return http.StatusOK, ""
}
