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
      debugShowCheckedModeBanner: false,
      title: 'Phone Number Details',
      theme: ThemeData.dark(),
      home: PhoneNumberDetailsPage(),
    );
  }
}

class PhoneNumberDetailsPage extends StatefulWidget {
  @override
  _PhoneNumberDetailsPageState createState() => _PhoneNumberDetailsPageState();
}

class _PhoneNumberDetailsPageState extends State<PhoneNumberDetailsPage> {
  String phoneNumber = "";
  Map<String, dynamic>? details;
  String? error;

  bool isLoading = false;

  Future<void> validateNumber() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    final url = Uri.parse(
        'https://api.apilayer.com/number_verification/validate?number=$phoneNumber');
    final headers = {
      'apikey': 'frfSXRd2MG33PKAtaE7PRLJZh226dkG5',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      print(responseData);

      setState(() {
        details = responseData;
        isLoading = false;
      });
    } else {
      print('Error: ${response.statusCode}');

      setState(() {
        error = 'Error occurred. Please try again.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Number Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Enter Phone no',
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                ),
              ),
              onChanged: (value) {
                phoneNumber = value;
              },
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              style: ButtonStyle(shadowColor:MaterialStateProperty.all<Color>(Colors.teal) ,
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.teal)),
              onPressed: isLoading ? null : validateNumber,
              child: Text('Get Details'),
            ),
            SizedBox(height: 16.0),
            if (isLoading)
              CircularProgressIndicator()
            else if (details != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 20),
                  child: Container(
                    width: 300,
                    decoration: BoxDecoration(
                      color: Color(0xFF343434),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.4),
                          spreadRadius: 5,
                          blurRadius: 8,
                          offset: Offset(
                              0, 3), // changes the position of the shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5,bottom: 5,right: 20,left: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Valid: ${details!["valid"]}'),
                          Text('Number: ${details!["number"]}'),
                          Text('Local Format: ${details!["local_format"]}'),
                          Text(
                              'International Format: ${details!["international_format"]}'),
                          Text('Country Code: ${details!["country_code"]}'),
                          Text('Country Name: ${details!["country_name"]}'),
                          Text('Location: ${details!["location"]}'),
                          Text('Carrier: ${details!["carrier"]}'),
                          Text('Line Type: ${details!["line_type"]}'),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            else if (error != null)
              Text(
                error!,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
