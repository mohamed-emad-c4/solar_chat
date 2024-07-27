import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scholar_chat/screens/loading_screen.dart';
import 'package:scholar_chat/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool hidePassword = true;
  bool isLoading = false;
  String? _email;
  String? _password;
  String? errorMessage = 'Good!!!';
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            fontSize: 30.0,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40.0),
                  _buildLogo(),
                  const SizedBox(height: 40.0),
                  _buildLoginHeader(),
                  const SizedBox(height: 30.0),
                  _buildEmailField(),
                  const SizedBox(height: 20.0),
                  _buildPasswordField(),
                  const SizedBox(height: 30.0),
                  _buildLoginButton(),
                  const SizedBox(height: 20.0),
                  _buildSignUpLink(),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
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

  Widget _buildLoginHeader() {
    return const Center(
      child: Text(
        'LOGIN',
        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
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
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
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

  Widget _buildLoginButton() {
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
          if (formKey.currentState!.validate()) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoadingScreen(),
              ),
            );
            setState(() {});
            try {
              final credential =
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: '$_email',
                password: '$_password',
              );
              context.go('/chat/$_email',);
            } on FirebaseAuthException catch (e) {
              switch (e.code) {
                case 'invalid-email':
                  errorMessage = 'The email address is not valid.';
                  break;
                case 'user-disabled':
                  errorMessage = 'The user account has been disabled.';
                  break;
                case 'user-not-found':
                  errorMessage = 'No user found for that email.';
                  break;
                case 'wrong-password':
                  errorMessage = 'Wrong password provided for that user.';
                  break;
                case 'email-already-in-use':
                  errorMessage =
                      'The email address is already in use by another account.';
                  break;
                case 'network-request-failed':
                  errorMessage =
                      'A network error has occurred. Please check your internet connection and try again.';
                  break;
                case 'too-many-requests':
                  errorMessage = 'Too many attempts. Please try again later.';
                  break;
                case 'timeout':
                  errorMessage =
                      'The request has timed out. Please try again later.';
                  break;
                case 'operation-not-allowed':
                  errorMessage = 'Email/password accounts are not enabled.';
                  break;
                case 'weak-password':
                  errorMessage = 'The password is too weak.';
                  break;
                default:
                  errorMessage = 'password or email is incorrect';

                  setState(() {
                    isLoading = false;
                  });
              }
              log(errorMessage!); // Log the error message or show it to the user
            } catch (e) {
              errorMessage = 'An unknown error occurred.';
              log(errorMessage!);

              setState(() {}); // Log the error message or show it to the user
            }
            Navigator.pop(context);
          }

          // ignore: avoid_print
          log("Login button pressed");
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(errorMessage!)));

          setState(() {});
        },
        child: const Text(
          'LOGIN',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account?"),
            TextButton(
              onPressed: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => const RegisterScreen(),
                //   ),
                // );
                context.go('/register');
              },
              child: const Text("Sign Up"),
            ),
          ],
        ),

        // Text(
        //   "$errorMessage!",
        //   style: const TextStyle(color: Colors.red),
        // ),
      ],
    );
  }
}
