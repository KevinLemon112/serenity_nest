import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'create_account_page.dart';
import 'main_lobby_page.dart'; // Import the Main Lobby class

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isDarkMode ? Colors.black : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color buttonColor = isDarkMode ? Colors.grey.shade600 : Colors.blue;
    Color createAccountButtonColor = isDarkMode ? Colors.grey.shade600 : Colors.yellow;
    Color googleButtonColor = isDarkMode ? Colors.grey.shade600 : Colors.green;
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
      body: Stack(
        children: [
          // Animated background container
          Container(
            color: backgroundColor,
          ),
          // Content of the login screen
          Padding(
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
                    border: OutlineInputBorder(),
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
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: textColor),
                  ),
                  obscureText: true,
                  style: TextStyle(color: textFieldTextColor),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      UserCredential userCredential =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      // Handle successful authentication, e.g., navigate to another screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MainLobbyPage()),
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
                  child: Text(
                    'Login',
                    style: TextStyle(color: textColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor, // Button color
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to create account screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateAccountPage()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: createAccountButtonColor, // Button color
                    ),
                    child: Text(
                      'Create Account',
                      style: TextStyle(color: textColor),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                // Google sign-in button
                ElevatedButton.icon(
                  onPressed: () async {
                    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
                    if (googleUser != null) {
                      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
                      final AuthCredential credential = GoogleAuthProvider.credential(
                        accessToken: googleAuth.accessToken,
                        idToken: googleAuth.idToken,
                      );
                      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
                      // Handle successful authentication, e.g., navigate to another screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MainLobbyPage()),
                      );
                    }
                  },
                  icon: Icon(Icons.login, color: textColor),
                  label: Text('Sign in with Google', style: TextStyle(color: textColor)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: googleButtonColor, // Button color
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
  ));
}