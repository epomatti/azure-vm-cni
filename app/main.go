package main

import (
	"database/sql"
	"fmt"
	"net/http"
	"net/url"
	"os"

	"github.com/joho/godotenv"
	_ "github.com/microsoft/go-mssqldb"
)

func main() {
	godotenv.Load()

	query := url.Values{}
	query.Add("app name", "MyAppName")

	hostname := os.Getenv("MSSQL_HOSTNAME")
	port := os.Getenv("MSSQL_PORT")
	username := os.Getenv("MSSQL_USERNAME")
	password := os.Getenv("MSSQL_PASSWORD")

	u := &url.URL{
		Scheme: "sqlserver",
		User:   url.UserPassword(username, password),
		Host:   fmt.Sprintf("%s:%s", hostname, port),
		// Path:  instance, // if connecting to an instance instead of a port
		RawQuery: query.Encode(),
	}

	db, err := sql.Open("sqlserver", u.String())

	if err != nil {
		panic(err)
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello, World!\n")
	})

	http.HandleFunc("/query", func(w http.ResponseWriter, r *http.Request) {
		row := db.QueryRow("SELECT 1")
		if row.Err() != nil {
			fmt.Println(err)
			w.WriteHeader(http.StatusInternalServerError)
			fmt.Fprintf(w, "Hello, World!\n")
		}
		var strrow string
		err := row.Scan(&strrow)
		if err != nil {
			fmt.Println(err)
			w.WriteHeader(http.StatusInternalServerError)
			fmt.Fprintf(w, "ERROR\n")
		}
		fmt.Println(strrow)
		fmt.Fprintf(w, fmt.Sprintf("%s\n", strrow))
	})

	err = http.ListenAndServe(":8080", nil)
	if err != nil {
		fmt.Println("Error starting the server:", err)
	}
}
