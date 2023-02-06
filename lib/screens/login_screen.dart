import 'package:flutter/material.dart';
import 'package:revamph/responsive/mobile_screen_layout.dart';
import 'package:revamph/responsive/responsive_layout.dart';
import 'package:revamph/responsive/web_screen_layout.dart';
import 'package:revamph/screens/signup_screen.dart';
import 'package:revamph/utils/utils.dart';
import '../resources/auth_methods.dart';
import '../utils/colors.dart';
import '../widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
  // login user

  void loginUser() async {
    setState(() {
      isLoading = true;
    });

    String res = await AuthModels().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (res == 'success') {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
          (route) => false);

      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      showSnackBar(context, res);
    }
  }

  // Navigate to sign up screen
  void navigateToSignUp() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SignupScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(flex: 2, child: Container()),
              const Text('LOGO', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 40),
              MyTextField(
                hintText: 'Email',
                texteditingController: _emailController,
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              MyTextField(
                isPass: true,
                hintText: 'Password',
                texteditingController: _passwordController,
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 30),
              InkWell(
                onTap: loginUser,
                child: Container(
                  width: double.infinity,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    color: AppColors.blueColor,
                  ),
                  child: const Text('LOGIN'),
                ),
              ),
              Flexible(flex: 2, child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 5),
                    child: const Text("Don't have an account?"),
                  ),
                  GestureDetector(
                    onTap: navigateToSignUp,
                    child: const Text('Signup'),
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
