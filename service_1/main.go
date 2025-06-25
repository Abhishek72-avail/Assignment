package main

import (
    "fmt"
    "log"
    "net/http"
    "os"
)

func main() {
    // Health check endpoint
    http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
        w.WriteHeader(http.StatusOK)
        w.Write([]byte("Service 1 (Go) is healthy"))
    })

    // Root endpoint
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        w.WriteHeader(http.StatusOK)
        w.Write([]byte("Hello from Go Service 1!"))
    })

    // Add your existing routes here...
    // Example:
    // http.HandleFunc("/api/users", usersHandler)

    // Get port from environment variable, default to 8001
    port := os.Getenv("PORT")
    if port == "" {
        port = "8001"
    }

    fmt.Printf("Go service starting on port %s\n", port)
    log.Fatal(http.ListenAndServe(":"+port, nil))
}