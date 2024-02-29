import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'create_account_page.dart';
import 'main_lobby_page.dart'; // Import the Main Lobby class

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SerenityNest Login',
          style: TextStyle(
            fontSize: 35.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background container with animated elements
          AnimatedBackground(),
          // Content of the login screen
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Your existing login fields
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
                  icon: const Icon(Icons.login),
                  label: const Text('Sign in with Google'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({Key? key}) : super(key: key);

  @override
  _AnimatedBackgroundState createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20), // Adjust duration as needed
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: BackgroundPainter(animation: _animation),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final Animation<double> animation;

  BackgroundPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    // Paint background color
    final backgroundPaint = Paint()..color = Colors.blue.shade400.withOpacity(0.5);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Calculate positions based on animation value
    final offset = Offset(size.width * animation.value, size.height / 2);

    // Draw sunset
    final sunPaint = Paint()..color = Colors.orange.shade400;
    canvas.drawCircle(offset, 100 + (animation.value * 20), sunPaint);

    // Draw birds
    final birdPaint = Paint()..color = Colors.black;
    final bird1 = Offset(size.width * 0.1, size.height * 0.1);
    final bird2 = Offset(size.width * 0.2, size.height * 0.15);
    final bird3 = Offset(size.width * 0.15, size.height * 0.3);
    canvas.drawCircle(bird1, 10, birdPaint);
    canvas.drawCircle(bird2, 10, birdPaint);
    canvas.drawCircle(bird3, 10, birdPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}