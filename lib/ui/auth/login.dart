import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
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

  void login() {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    authService.login(email: email, password: password).then((data) {
      if (data != null) {
        showToast(context, "Successfully Logged in");
        context.push("/main");
        print("success");
      } else {
        print("failed");
        showToast(context, "invalid email or password");
      }
    }).catchError((err) {
      print(err);
      showToast(context, err ?? "login failed");
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
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: login,
                  child: const Text("Login"),
                ),
                TextButton(
                  onPressed: () {
                    context.push("/register");
                  },
                  child: const Text("Signup"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
