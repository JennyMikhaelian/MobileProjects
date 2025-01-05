import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController(); // Address controller

  // Function to handle login submission
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String phone = _phoneController.text;
      String address = _addressController.text; // Capture address input

      try {
        // API endpoint for your PHP login script
        final url = Uri.parse("http://10.0.2.2/pizza/login.php");

        // Send user data to the backend
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"name": name, "phone": phone, "address": address}), // Include address
        );

        // Check the response status
        if (response.statusCode == 200) {
          print('Response body: ${response.body}');
          final responseData = jsonDecode(response.body);

          if (responseData['error'] != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${responseData['error']}")),
            );
          } else {
            int userId = responseData['user_id'];
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseData['message'])),
            );
            Navigator.pushReplacementNamed(
              context,
              '/home',
              arguments: {'user_id': userId},
            );
          }
        } else {
          print('Failed response: ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to connect to the server")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Papa\'s Pizzeria',
          style: TextStyle(fontFamily: 'Pacifico', fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset("assets/images/pizzalogo.jpg"),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Fill to Continue',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        } else if (!RegExp(r'^\d{8}$').hasMatch(value)) {
                          return 'Enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
