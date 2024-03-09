import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main_lobby_page.dart'; // Import the MainLobbyPage class

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();
  bool isDarkMode = false;

  void toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color buttonColor = isDarkMode ? Colors.grey.shade600 : Colors.blue;
    Color textFieldBackground = isDarkMode ? Colors.grey.shade600 : Colors.grey.shade100;
    Color textFieldTextColor = isDarkMode ? Colors.white : Colors.black;
    Color backgroundColor = isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Create Account',
              style: TextStyle(color: textColor, fontSize: 29.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: textColor,
              ),
              onPressed: toggleDarkMode,
            ),
          ],
        ),
        backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
      ),
      body: Container(
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Email TextField
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: textFieldBackground,
                  border: const OutlineInputBorder(),
                  labelStyle: TextStyle(color: textColor),
                ),
                style: TextStyle(color: textFieldTextColor),
              ),
              const SizedBox(height: 16.0),
              // Password TextField
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: true,
                  fillColor: textFieldBackground,
                  border: const OutlineInputBorder(),
                  labelStyle: TextStyle(color: textColor),
                ),
                obscureText: true,
                style: TextStyle(color: textFieldTextColor),
              ),
              const SizedBox(height: 16.0),
              // Repeat Password TextField
              TextField(
                controller: repeatPasswordController,
                decoration: InputDecoration(
                  labelText: 'Repeat Password',
                  filled: true,
                  fillColor: textFieldBackground,
                  border: const OutlineInputBorder(),
                  labelStyle: TextStyle(color: textColor),
                ),
                obscureText: true,
                style: TextStyle(color: textFieldTextColor),
              ),
              const SizedBox(height: 16.0),
              // Create Account Button
              ElevatedButton(
                onPressed: () async {
                  // Validate email
                  if (!isValidEmail(emailController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please enter a valid email'),
                    ));
                    return;
                  }

                  // Validate password match
                  if (passwordController.text != repeatPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Passwords do not match'),
                    ));
                    return;
                  }

                  try {
                    // Create user with email and password
                    UserCredential userCredential =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );

                    // Store additional user information in Firestore
                    await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
                      'email': emailController.text,
                      'displayName': '', // Add display name if needed
                    });

                    // Show account creation success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Account Creation Successful'),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    // Navigate to the main lobby page after successful account creation
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainLobbyPage()),
                    );
                  } catch (e) {
                    // Handle account creation errors
                    print('Error creating account: $e');
                    String errorMessage = 'An error occurred. Please try again.';
                    if (e is FirebaseAuthException) {
                      switch (e.code) {
                        case 'email-already-in-use':
                          errorMessage = 'An account already exists with this email.';
                          break;
                        case 'weak-password':
                          errorMessage = 'The password is too weak.';
                          break;
                      }
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(errorMessage),
                      ),
                    );
                  }
                },
                child: Text(
                  'Create Account',
                  style: TextStyle(color: textColor),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    return email.isNotEmpty && email.contains('@');
  }
}