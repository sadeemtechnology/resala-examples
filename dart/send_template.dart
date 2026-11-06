// Send an approved template to one or more Libyan numbers (package:http).
// Usage: RESALA_API_KEY=... dart run send_template.dart TEMPLATE_ID 218910001234
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> main(List<String> args) async {
  if (args.isEmpty) { print('Usage: dart run send_template.dart TEMPLATE_ID PHONE'); return; }
  final templateId = args[0];
  final phone = args.length > 1 ? args[1] : '218910001234';

  final res = await http.post(
    Uri.https('dev.resala.ly', '/api/v1/messages/send-template', {'sms_template_id': templateId}),
    headers: {
      'Authorization': 'Bearer ${Platform.environment['RESALA_API_KEY']}',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'records': [
        {'phone': phone, r'$1': 'Resala', r'$2': 'Ahmed'},
      ],
    }),
  );
  final data = jsonDecode(res.body);
  if (res.statusCode >= 400) throw HttpException('${res.statusCode} ${data['type']}: ${data['message']}');
  print('sent ${data['succeeded']}, failed ${data['failed']}, cost ${data['total_cost']} LYD');
}
