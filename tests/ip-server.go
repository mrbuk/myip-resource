package main

import (
	"fmt"
	"log"
	"net/http"
)

var ip = "1.1.1.2"

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "%s", ip)
}

func main() {
	http.HandleFunc("/", handler)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
