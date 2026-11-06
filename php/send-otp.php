<?php
// Send an OTP code with Resala using PHP's cURL extension (PHP 8+).
// Usage: RESALA_API_KEY=... php send-otp.php 218910001234
$phone  = $argv[1] ?? '218910001234';
$apiKey = getenv('RESALA_API_KEY') ?: throw new RuntimeException('Set RESALA_API_KEY');

$query = http_build_query(['service_name' => 'MyApp']); // add 'test' => '' for test mode, 'sender' => 'MyBrand' for a sender name
$ch = curl_init("https://dev.resala.ly/api/v1/pins?$query");
curl_setopt_array($ch, [
    CURLOPT_POST           => true,
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_TIMEOUT        => 15,
    CURLOPT_HTTPHEADER     => ["Authorization: Bearer $apiKey", 'Content-Type: application/json'],
    CURLOPT_POSTFIELDS     => json_encode(['phone' => $phone]),
]);
$body   = curl_exec($ch);
$status = curl_getinfo($ch, CURLINFO_RESPONSE_CODE);
curl_close($ch);

$data = json_decode($body, true, 512, JSON_THROW_ON_ERROR);
if ($status >= 400) {
    // Branch on $data['type'] (InsufficientCredit, InputValidation, ...), not on the localized message.
    throw new RuntimeException("$status {$data['type']}: {$data['message']} (request_id {$data['request_id']})");
}

// Store $data['pin'] server-side (session/DB) and compare it with the user's input; enforce your own expiry.
echo "sent {$data['id']} pin {$data['pin']} sender {$data['sender_name']}\n";
