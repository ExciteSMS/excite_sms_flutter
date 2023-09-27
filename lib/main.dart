import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Excite SMS Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController recipientController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  String confirmationMessage = '';

  Future<void> sendSMS() async {
    final apiUrl = Uri.parse('https://gateway.excitesms.tech/api/v3/sms/send');
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer  ',
    };

    final payload = {
      'recipient': recipientController.text,
      'sender_id': 'ExciteSMS',
      'message': messageController.text,
    };

    final response =
        await http.post(apiUrl, headers: headers, body: jsonEncode(payload));

    if (response.statusCode == 200) {
      setState(() {
        confirmationMessage = 'SMS sent successfully';
      });
    } else {
      setState(() {
        confirmationMessage = 'Error sending SMS';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Excite SMS Flutter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Send SMS using Excite SMS API',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            TextField(
              controller: recipientController,
              decoration: InputDecoration(
                labelText: 'Recipient',
              ),
            ),
            TextField(
              controller: messageController,
              decoration: InputDecoration(
                labelText: 'Message',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendSMS,
              child: Text('Send SMS'),
            ),
            SizedBox(height: 20),
            Text(
              confirmationMessage,
              style: TextStyle(
                fontSize: 18,
                color: confirmationMessage.contains('Error')
                    ? Colors.red
                    : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
