import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawprints/services/auth.service.dart';
import 'package:pawprints/ui/utils/toast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService authService = AuthService();
  bool _isPasswordVisible = false; // State variable for password visibility

  void login() {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    authService.login(email: email, password: password).then((data) {
      if (data != null) {
        showToast(context, "Successfully Logged in");
        context.push("/dashboard");
      } else {
        showToast(context, "Invalid email or password");
      }
    }).catchError((err) {
      showToast(context, err ?? "Login failed");
    });
  }

  void getCurrentUser() {
    authService.authStateChanges().listen((user) {
      if (user != null) {
        context.push("/main");
      }
    });
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 50),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    'lib/assets/img/paw_logo.png', // Add your logo here
                    height: 100,
                  ),
                ),
                const Text(
                  "PAWPRINTS",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Text(
                  "Aucena Veterinary Clinic",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined),
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText:
                      !_isPasswordVisible, // Use the state variable here
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility // Show password icon
                            : Icons.visibility_off, // Hide password icon
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible =
                              !_isPasswordVisible; // Toggle visibility
                        });
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Forgot Password logic here
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    backgroundColor: const Color(0xFF001B44),
                  ),
                  onPressed: login,
                  child: const Text(
                    "Log In",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    context.push("/register");
                  },
                  child: const Text("Signup",
                      style: TextStyle(color: Colors.black54)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
