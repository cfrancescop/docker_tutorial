package main

import (
	"database/sql"
	"fmt"
	"log"

	"github.com/gin-gonic/gin"
)

// User json data
type User struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

func getConnection() *sql.DB {
	dbuser := "root"
	dbpassword := "s3kreee7"
	dbname := "hrm_test"
	dbhost := "192.168.50.164"
	dbstring := fmt.Sprintf("%s:%s@tcp(%s)/%s", dbuser, dbpassword, dbhost, dbname)
	db, err := sql.Open("mysql", dbstring)
	if err != nil {
		panic(err.Error()) // Just for example purpose. You should use proper error handling instead of panic
	}

	// Open doesn't open a connection. Validate DSN data:
	err = db.Ping()
	if err != nil {
		panic(err.Error()) // proper error handling instead of panic in your app
	}
	return db
}
func main() {
	r := gin.Default()
	r.GET("/", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"text": "Hello World",
		})
	})

	r.GET("/users", func(c *gin.Context) {
		db := getConnection()
		defer db.Close()
		rows, err := db.Query("SELECT user,password FROM users ")
		// date := t.Format("2006-01-01")
		if err != nil {
			panic(err.Error()) // proper error handling instead of panic in your app
		}
		defer rows.Close()
		utenti := make([]*User, 0)
		for rows.Next() {
			utente := new(User)
			//t := make([]byte, 0)
			if err := rows.Scan(&utente.Username, &utente.Password); err != nil {
				log.Fatal(err)
			}
			//fmt.Println(t2, t2.Unix())
			//fmt.Printf("IUV: %v\n", pagamento.Iuv)
			utenti = append(utenti, utente)
		}
		c.JSON(200, utenti)
	})
	r.Run() // listen and serve on 0.0.0.0:8080
}
