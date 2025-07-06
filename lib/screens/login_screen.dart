import 'package:flutter/material.dart';
import 'package:ProductDemoApp/global.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  bool _isPasswordVisible = false;
  bool _isFormValid = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  void _validateInputFields() {
    bool isEmailValid = Validators.validateEmail(emailController.text) == null;
    bool isPasswordValid = passwordController.text.isNotEmpty;

    setState(() {
      _isFormValid = isEmailValid && isPasswordValid;
    });
  }

  void _loginAction() {
    if (_formKey.currentState!.validate()) {
      _login();
    }
  }

  Future<void> _login() async {
    setState(() => isLoading = true);

    // Simulate a short delay
    await Future.delayed(const Duration(seconds: 1));

    const hardcodedEmail = 'sumerkamble3@gmail.com';
    const hardcodedPassword = '12345678';

    if (emailController.text == hardcodedEmail &&
        passwordController.text == hardcodedPassword) {
      if (!mounted) return;
      setState(() => isLoading = false);

      SnackbarService.showSnackbar(
        context,
        "✅ Login successful",
        duration: const Duration(seconds: 1),
      );

      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
              (route) => false,
        );
      });
    } else {
      setState(() => isLoading = false);
      SnackbarService.showSnackbar(
        context,
        "❌ Invalid email or password",
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 80),
              Column(
                children: [
                  Image.asset(
                    'assets/appLogo/mock_logo.png',
                    width: 300,
                    height: 150,
                  ),
                  const Text(
                    'Product',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: emailController,
                focusNode: emailFocus,
                decoration: CustomInputTheme.customInputDecoration(
                  labelText: "Email",
                  prefixIcon: Icons.mail,
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onChanged: (_) => _validateInputFields(),
                validator: (value) => Validators.validateEmail(value ?? ""),
                onFieldSubmitted: (_) {
                  if (_formKey.currentState!.validate()) {
                    FocusScope.of(context).requestFocus(passwordFocus);
                  }
                },
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: passwordController,
                focusNode: passwordFocus,
                decoration: CustomInputTheme.customInputDecoration(
                  labelText: "Password",
                  prefixIcon: Icons.lock,
                ).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
                textInputAction: TextInputAction.done,
                validator: (value) => Validators.validatePassword(value ?? ""),
                onChanged: (_) => _validateInputFields(),
                onFieldSubmitted: (_) => _loginAction(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isFormValid ? _loginAction : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(AppInputTheme.cornerRadius),
                  ),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              if (isLoading)
                const CircularProgressIndicator(
                  color: AppColors.secondaryColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
