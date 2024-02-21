import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main_lobby_page.dart'; // Import the MainLobbyPage class

class CreateAccountPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();

  CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: repeatPasswordController,
              decoration: const InputDecoration(labelText: 'Repeat Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Validate email
                if (!isValidEmail(emailController.text)) {
                  // Show error message for invalid email
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please enter a valid email'),
                  ));
                  return;
                }

                // Validate password match
                if (passwordController.text != repeatPasswordController.text) {
                  // Show error message for password mismatch
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Passwords do not match'),
                  ));
                  return;
                }

                try {
                  // Create user with email and password
                  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );

                  // Store additional user information (e.g., username) in Firestore
                  await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
                    'username': usernameController.text,
                  });

                  // Navigate to Main Lobby Page after successful account creation
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
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    // Simple email validation
    return email.isNotEmpty && email.contains('@');
  }
}