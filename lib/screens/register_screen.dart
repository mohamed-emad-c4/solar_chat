import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

String? _email;
String? _password;
String? errorMessage='Good!!!';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
          style: TextStyle(
            fontSize: 30.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40.0),
              _buildLogo(),
              const SizedBox(height: 40.0),
              _buildRegisterHeader(),
              const SizedBox(height: 30.0),
              _buildEmailField(),
              const SizedBox(height: 20.0),
              _buildPasswordField(),
              const SizedBox(height: 20.0),
              _buildRegisterButton(),
              const SizedBox(height: 20.0),
              _buildLoginLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Image.asset('assets/images/scholar.png', scale: 0.5),
    );
  }

  Widget _buildRegisterHeader() {
    return const Center(
      child: Text(
        'REGISTER',
        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) => _email = value,
      decoration: InputDecoration(
        labelText: 'Email',
        prefixIcon: const Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      obscureText: hidePassword,
      onChanged: (value) => _password = value,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(hidePassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              hidePassword = !hidePassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextField(
      obscureText: hideConfirmPassword,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
              hideConfirmPassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              hideConfirmPassword = !hideConfirmPassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      height: 60.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        onPressed: () async {
          try {
            UserCredential thisUser =
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: '$_email',
              password: '$_password',
            );
            log("Register button pressed");
          } catch (e) {
            if (e is FirebaseAuthException) {
              switch (e.code) {
                case 'email-already-in-use':
                  errorMessage =
                      'The email address is already in use by another account.';
                  break;
                case 'invalid-email':
                  errorMessage = 'The email address is not valid.';
                  break;
                case 'operation-not-allowed':
                  errorMessage = 'Email/password accounts are not enabled.';
                  break;
                case 'weak-password':
                  errorMessage = 'The password is too weak.';
                  break;
                default:
                  errorMessage = 'An undefined error happened: ${e.message}';
              }
            } else {
              errorMessage = 'An unknown error occurred.';
            }
            log(errorMessage!); // Log the error message or show it to the user
          }
           setState(() {
            
          });
        },
        child: const Text(
          'Register',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Column(
      children: [
        const SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Already have an account?"),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Login"),
            ),
          ],
        ),
        Text("$errorMessage!",style: TextStyle(color: Colors.red),),
      ],
    );
  }
}
