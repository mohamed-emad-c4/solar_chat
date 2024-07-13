import 'dart:developer';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool hidepassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff97AEC7),
      appBar: AppBar(
        backgroundColor: const Color(0xff97AEC7),
        title: const Text(
          'Register',
          style: TextStyle(fontSize: 30.0),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9.0),
          child: Column(
            children: [
              Image.asset('assets/images/scholar.png', scale: 0.5),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'REGISTER',
                    style: TextStyle(fontSize: 30.0),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              const TextField(
                maxLines: 1,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                  prefixIcon: Icon(Icons.email),
                  label: Text("Email"),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 66, 221, 0),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                maxLines: 1,
                obscureText: hidepassword,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      hidepassword = !hidepassword;
                      setState(() {});
                    },
                    icon: Icon(
                        hidepassword ? Icons.visibility : Icons.visibility_off),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  prefixIcon: const Icon(Icons.password),
                  label: const Text("Password"),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 24, 120, 199),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: () => log("pressed botton"),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 21, 0, 139),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  width: double.infinity,
                  height: 60.0,
                  child: const Center(
                    child: Text(
                      "Register",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(fontSize: 15.0),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
