<?php
// Send an approved template to one or more Libyan numbers.
// Usage: RESALA_API_KEY=... php send-template.php TEMPLATE_ID 218910001234
[$templateId, $phone] = [$argv[1] ?? null, $argv[2] ?? '218910001234'];
$templateId ?: exit("Usage: php send-template.php TEMPLATE_ID PHONE\n");

$ch = curl_init('https://dev.resala.ly/api/v1/messages/send-template?' . http_build_query(['sms_template_id' => $templateId]));
curl_setopt_array($ch, [
    CURLOPT_POST           => true,
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_HTTPHEADER     => ['Authorization: Bearer ' . getenv('RESALA_API_KEY'), 'Content-Type: application/json'],
    CURLOPT_POSTFIELDS     => json_encode(['records' => [
        ['phone' => $phone, '$1' => 'Resala', '$2' => 'Ahmed'],
    ]], JSON_UNESCAPED_UNICODE),
]);
$data = json_decode(curl_exec($ch), true);
curl_close($ch);
printf("sent %d, failed %d, cost %s LYD\n", $data['succeeded'] ?? 0, $data['failed'] ?? 0, $data['total_cost'] ?? '-');
