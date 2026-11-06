// Send an OTP code with Resala from Dart / Flutter using dart:io only.
// Usage: RESALA_API_KEY=... dart run send_otp.dart 218910001234
// In Flutter, run this on your backend or use package:http with the same request.
import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  final phone = args.isNotEmpty ? args.first : '218910001234';
  final apiKey = Platform.environment['RESALA_API_KEY'] ?? (throw StateError('Set RESALA_API_KEY'));

  final uri = Uri.https('dev.resala.ly', '/api/v1/pins', {
    'service_name': 'MyApp',
    // 'test': '',          // test mode: nothing sent, nothing charged
    // 'sender': 'MyBrand', // registered sender name
    // 'autofill': 'APP_SIGNATURE', // Android SMS autofill hash
  });

  final client = HttpClient();
  final req = await client.postUrl(uri);
  req.headers.set(HttpHeaders.authorizationHeader, 'Bearer $apiKey');
  req.headers.contentType = ContentType.json;
  req.write(jsonEncode({'phone': phone}));
  final res = await req.close();
  final data = jsonDecode(await res.transform(utf8.decoder).join()) as Map<String, dynamic>;
  client.close();

  if (res.statusCode >= 400) {
    // Branch on data['type'] (InsufficientCredit, InputValidation, ...), not on the localized message.
    throw HttpException('${res.statusCode} ${data['type']}: ${data['message']} (request_id ${data['request_id']})');
  }
  // Store data['pin'] server-side and compare it with the user's input; enforce your own expiry.
  print('sent ${data['id']} pin ${data['pin']} sender ${data['sender_name']}');
}
