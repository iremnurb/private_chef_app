import 'package:diyet/ui/views/home/ana_sayfa.dart';
import 'package:diyet/ui/views/login/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/repo/repository.dart';
import '../../cubit/login_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../cubit/profile_cubit.dart';

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Log in",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Enter your email and password",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Email",
                    style: GoogleFonts.poppins(
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
                      hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                      border: InputBorder.none,
                      errorText: errorMessage,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Divider(color: Colors.black, thickness: 1),
                  const SizedBox(height: 16),
                  Text(
                    "Password",
                    style: GoogleFonts.poppins(
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
                      hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
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
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Divider(color: Colors.black, thickness: 1),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Forgot Password?",
                        style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
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

                  final user = context.read<LoginCubit>().state;
                  if (user != null) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setInt('userId', user.id as int);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(value: context.read<LoginCubit>()),
                            BlocProvider.value(
                              value: context.read<ProfileCubit>()..setUser(user),
                            ),
                          ],
                          child: const AnaSayfa(),
                        ),
                      ),
                    );
                  } else {
                    setState(() {
                      errorMessage = "Login failed: Incorrect email or password";
                    });
                  }
                },
                child: Text(
                  "Log In",
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUp()),
                );
              },
              child: RichText(
                text: TextSpan(
                  text: "Don’t have an account? ",
                  style: GoogleFonts.poppins(color: Colors.black, fontSize: 14),
                  children: [
                    TextSpan(
                      text: "Sign up",
                      style: GoogleFonts.poppins(
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