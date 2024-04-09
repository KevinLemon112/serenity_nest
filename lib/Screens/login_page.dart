import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'create_account_page.dart';
import 'main_lobby_page.dart'; // Import the Main Lobby class

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isDarkMode = false;

  void toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  Future<void> signInWithEmailPassword() async {
    try {
      final String email = emailController.text.trim();
      final String password = passwordController.text.trim();

      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to the main lobby page on successful sign-in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainLobbyPage()),
      );
    } on FirebaseAuthException catch (e) {
      // Handle authentication errors
      String errorMessage = 'An error occurred. Please try again.';

      if (e.code == 'user-not-found') {
        errorMessage = 'No account found with this email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Invalid password.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in with the credential
        await FirebaseAuth.instance.signInWithCredential(credential);

        // Get the user's display name from Google account
        String? userName = googleUser.displayName;

        // Navigate to the main lobby page on successful sign-in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainLobbyPage(userName: userName)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to sign in with Google. Please try again.'),
        ),
      );
    }
  }

  Future<void> sendResetPasswordEmail() async {
    final String email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an email address in the email text box before clicking the reset password button.'),
        ),
      );
      return; // Exit the method if email is empty
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent. Check your email inbox.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send password reset email. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isDarkMode ? Colors.black : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color buttonColor = isDarkMode ? Colors.grey.shade600 : Colors.blue;
    Color textFieldBackground = isDarkMode ? Colors.grey.shade600 : Colors.grey.shade100;
    Color textFieldTextColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'SerenityNest Login',
              style: TextStyle(
                fontSize: 29.0,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            IconButton(
              onPressed: toggleDarkMode,
              icon: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: textColor,
              ),
            ),
          ],
        ),
        backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
      ),
      body: Container(
        color: backgroundColor,
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Your existing login fields
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
                  ElevatedButton(
                    onPressed: signInWithEmailPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor, // Button color
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(color: textColor),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to create account screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CreateAccountPage()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: isDarkMode ? Colors.grey.shade600 : Colors.yellow, // Button color
                      ),
                      child: Text(
                        'Create Account',
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Reset password button
                  TextButton(
                    onPressed: sendResetPasswordEmail,
                    style: TextButton.styleFrom(
                      backgroundColor: isDarkMode ? Colors.grey.shade600 : Colors.red, // Button color
                      padding: const EdgeInsets.all(16.0),
                    ),
                    child: Text(
                      'Reset Password',
                      style: TextStyle(color: textColor),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Google sign-in button
                  ElevatedButton.icon(
                    onPressed: () => signInWithGoogle(context),
                    icon: Icon(Icons.login, color: textColor),
                    label: Text('Sign in with Google', style: TextStyle(color: textColor)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode ? Colors.grey.shade600 : Colors.green, // Button color
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: LoginScreen(),
  ));
}