import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart'; // Import the LoginScreen class
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountHelpPage extends StatefulWidget {
  const AccountHelpPage({super.key});

  @override
  AccountHelpPageState createState() => AccountHelpPageState();
}

class AccountHelpPageState extends State<AccountHelpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isDarkMode = false;

  void toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  Future<void> sendResetPasswordEmail() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both email and password before attempting to reset the password.'),
        ),
      );
      return; // Exit the method if email or password is empty
    }

    try {
      // Reauthenticate the user with email and password
      User? user = FirebaseAuth.instance.currentUser;
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
      await user?.reauthenticateWithCredential(credential);

      // Check if the email exists in the Firestore users collection
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      final List<DocumentSnapshot> documents = result.docs;

      if (documents.isEmpty) {
        // Email does not exist
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No account found with this email.'),
          ),
        );
        return;
      }

      // Email exists, send the reset password email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent. Check your email inbox (and spam as well).'),
        ),
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-mismatch') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You have been signed out. Please login again before attempting.'),
            ),
          );
        } else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid credential provided. Please try again.'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to send password reset email. Please try again.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An unexpected error occurred. Please try again later.'),
          ),
        );
      }
    }
  }

  Future<void> deleteAccount() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both email and password before attempting to delete the account.'),
        ),
      );
      return; // Exit the method if email or password is empty
    }

    try {
      // Reauthenticate the user before deleting the account
      User? user = FirebaseAuth.instance.currentUser;
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
      await user?.reauthenticateWithCredential(credential);

      await user?.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account deleted successfully.'),
        ),
      );

      // Navigate back to the login screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false, // Remove all routes below the login page
      );
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Incorrect password. Please try again.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete account. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isDarkMode ? Colors.black : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color buttonColor = isDarkMode ? Colors.grey.shade600 : Colors.red;
    Color textFieldBackground = isDarkMode ? Colors.grey.shade600 : Colors.grey.shade100;
    Color textFieldTextColor = isDarkMode ? Colors.white : Colors.black;
    Color buttonTextColor = isDarkMode ? Colors.white : Colors.black; // Text color for buttons

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Account Help',
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                onPressed: sendResetPasswordEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor, // Button color
                ),
                child: Text(
                  'Reset Password',
                  style: TextStyle(color: buttonTextColor), // Button text color
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: deleteAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? Colors.grey.shade600 : Colors.red, // Button color
                ),
                child: Text(
                  'Delete Account',
                  style: TextStyle(color: buttonTextColor), // Button text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
