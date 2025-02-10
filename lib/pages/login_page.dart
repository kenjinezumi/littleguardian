// login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // for kReleaseMode
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmail() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    // Debug mode login bypass: skip auth if fields are empty and not in release mode
    if (email.isEmpty && password.isEmpty) {
      if (!kReleaseMode) {
        // In debug or profile mode, bypass login
        Navigator.pushReplacementNamed(context, '/home');
        return;
      } else {
        // In release mode, empty fields should not bypass; show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter email and password')),
        );
        return;
      }
    }
    try {
      // Sign in with email/password :contentReference[oaicite:3]{index=3}
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // If successful, navigate to Home
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      // Show error (e.g., wrong password, user not found)
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else {
        message = 'Authentication failed: ${e.message}';
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      // Trigger the Google authentication flow
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return; // The user canceled the sign-in
      }
      // Obtain the auth details from the request
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      // Create a credential for Firebase with the tokens :contentReference[oaicite:4]{index=4}
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Sign in to Firebase with the Google [User] credential
      await FirebaseAuth.instance.signInWithCredential(credential);
      // Navigate to Home on success
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign-in failed: ${e.message}')),
      );
    } catch (e) {
      // Generic error handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during Google Sign-In.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App title or logo can go here
                            Text(
                'Welcome',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 20),
              // Email TextField
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              // Password TextField
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              // Email Sign In Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _signInWithEmail,
                  child: Text('Sign In'),
                ),
              ),
              SizedBox(height: 16),
              // Google Sign In Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _signInWithGoogle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),                  
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.login, color: Colors.black), // Placeholder for Google icon
                      SizedBox(width: 8),
                      Text('Sign in with Google'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Phone Sign In Button
              TextButton(
                onPressed: () {
                  // Navigate to phone authentication flow (enter phone number)
                  Navigator.pushNamed(context, '/phone');
                },
                child: Text('Sign in with Phone'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
