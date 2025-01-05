import 'package:flutter/material.dart';
import 'package:jenny_papas_pizzeria/login.dart';
class ThankYouPage extends StatelessWidget {
  final int orderId;

  const ThankYouPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thank You!',
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
                child: Image.asset("assets/images/thank_you.jpg"), // Your thank you image
              ),
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  'Thank you for your order!',
                  style: TextStyle(
                    fontSize: 28,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Center(
                child: Text(
                  'We\'ll contact you in a bit.',
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Order Information:',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Card(
                color: Colors.amber.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Order ID: #$orderId',
                        style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your pizza is being prepared. We\'ll notify you when it\'s ready for delivery.',
                        style: const TextStyle(fontSize: 18, fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Replace with your login page widget or route
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()), // Change LoginPage() to your actual login widget
                        (Route<dynamic> route) => false, // This removes all previous pages from the stack
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber, // Use backgroundColor instead of primary
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Go Back to Login',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
