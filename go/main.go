// Send an OTP code with Resala using the Go standard library.
// Usage: RESALA_API_KEY=... go run . 218910001234
package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"net/url"
	"os"
	"time"
)

type pinResponse struct {
	ID         string `json:"id"`
	Pin        string `json:"pin"`
	Number     string `json:"number"`
	SenderName string `json:"sender_name"`
}

type apiError struct {
	Status    int    `json:"status"`
	Type      string `json:"type"`
	Message   string `json:"message"`
	RequestID string `json:"request_id"`
}

func main() {
	phone := "218910001234"
	if len(os.Args) > 1 {
		phone = os.Args[1]
	}
	apiKey := os.Getenv("RESALA_API_KEY")
	if apiKey == "" {
		fmt.Fprintln(os.Stderr, "Set RESALA_API_KEY")
		os.Exit(1)
	}

	q := url.Values{"service_name": {"MyApp"}} // q.Set("test", "") for test mode; q.Set("sender", "MyBrand") for a sender name
	body, _ := json.Marshal(map[string]string{"phone": phone})
	req, _ := http.NewRequest(http.MethodPost, "https://dev.resala.ly/api/v1/pins?"+q.Encode(), bytes.NewReader(body))
	req.Header.Set("Authorization", "Bearer "+apiKey)
	req.Header.Set("Content-Type", "application/json")

	res, err := (&http.Client{Timeout: 15 * time.Second}).Do(req)
	if err != nil {
		panic(err)
	}
	defer res.Body.Close()

	if res.StatusCode >= 400 {
		var e apiError
		_ = json.NewDecoder(res.Body).Decode(&e)
		// Branch on e.Type (InsufficientCredit, InputValidation, ...), not on the localized message.
		fmt.Fprintf(os.Stderr, "%d %s: %s (request_id %s)\n", res.StatusCode, e.Type, e.Message, e.RequestID)
		os.Exit(1)
	}

	var out pinResponse
	if err := json.NewDecoder(res.Body).Decode(&out); err != nil {
		panic(err)
	}
	// Store out.Pin server-side and compare it with the user's input; enforce your own expiry.
	fmt.Printf("sent %s pin %s sender %s\n", out.ID, out.Pin, out.SenderName)
}
