package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello at path %s", r.URL.Path[1:])
	})

	http.HandleFunc("/liveness", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprint(w, "ready")
	})

	http.HandleFunc("/readiness", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprint(w, "ready")
	})

	fmt.Println("Listening on port 8080")
	http.ListenAndServe(":8080", nil)
}
