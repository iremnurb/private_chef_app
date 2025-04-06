

import 'package:diyet/ui/views/login/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/login_cubit.dart';
import '../bottom_navigation.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Üst kısım (Arka plan resmi)
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/login_ust.png"),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 65),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Log in",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Enter your email and password",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Email Girişi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Enter your email",
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: InputBorder.none,
                      errorText: errorMessage,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Divider(color: Colors.black, thickness: 1),
                  const SizedBox(height: 16),

                  // Şifre Girişi
                  Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: "Enter your password",
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Divider(color: Colors.black, thickness: 1),

                  const SizedBox(height: 10),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 60),

            // Log In Butonu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C8C03),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () async {
                  if (emailController.text.isEmpty || !emailController.text.contains('@')) {
                    setState(() {
                      errorMessage = "Please enter a valid email address";
                    });
                    return;
                  }

                  await context.read<LoginCubit>().login(
                    emailController.text,
                    passwordController.text,
                  );

                  // Kullanıcı bilgisi alındıktan sonra kontrol
                  final user = context.read<LoginCubit>().state;
                  if (user != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => BottomNavigation()),
                    );
                  } else {
                    setState(() {
                      errorMessage = "Login failed: Incorrect email or password";
                    });
                  }
                },
                child: const Text(
                  "Log In",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),


            const SizedBox(height: 20),




            const SizedBox(height: 10),

            // Signup Text
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUp()),
                );
              },
              child: RichText(
                text: const TextSpan(
                  text: "Don’t have an account? ",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  children: [
                    TextSpan(
                      text: "Sign up",
                      style: TextStyle(
                        color: Color(0xFF7C8C03),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
