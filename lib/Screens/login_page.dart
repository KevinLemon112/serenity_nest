import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'create_account_page.dart';
import 'main_lobby_page.dart'; // Import the Main Lobby class

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email/Username'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  // Handle successful authentication, e.g., navigate to another screen
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainLobbyPage()),
                  );
                } catch (e) {
                  // Handle authentication errors, e.g., display error message to user
                  print('Error signing in: $e');
                  String errorMessage = 'An error occurred. Please try again.';
                  if (e is FirebaseAuthException) {
                    switch (e.code) {
                      case 'user-not-found':
                        errorMessage = 'No account found with this email.';
                        break;
                      case 'wrong-password':
                        errorMessage = 'Invalid password.';
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
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                // Navigate to create account screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateAccountPage()),
                );
              },
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}