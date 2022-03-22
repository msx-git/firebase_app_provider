import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';
import 'package:firebase_app_provider/models/custom_error.dart';
import 'package:firebase_app_provider/utils/error_dialog.dart';
import '../providers/providers.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);
  static const String routeName = '/signup';

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String? _email, _password, _name;
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;
    if (form == null && !form!.validate()) return;

    form.save();

    try {
      await context
          .read<SignupProvider>()
          .signup(name: _name!, email: _email!, password: _password!);
    } on CustomError catch (e) {
      errorDialog(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final signupState = context.watch<SignupProvider>().state;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: ListView(
                reverse: true,
                shrinkWrap: true,
                children: [
                  Hero(
                    tag: 'logo',
                    child: Image.asset(
                      'assets/images/flutter_logo.png',
                      width: 200,
                      height: 200,
                    ),
                  ),
                  const SizedBox(height: 20),
                  //Name input
                  TextFormField(
                    autocorrect: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.account_box),
                    ),
                    validator: (String? value) {
                      if (value == null && value!.trim().isEmpty) {
                        return 'Name required';
                      }
                      if (value.trim().length < 2) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      _name = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  //Email input
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (String? value) {
                      if (value == null && value!.trim().isEmpty) {
                        return 'Email required';
                      }
                      if (!isEmail(value.trim())) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      _email = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  //Password input
                  TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (String? value) {
                      if (value == null && value!.trim().isEmpty) {
                        return 'Password required';
                      }
                      if (value.trim().length<6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      _password = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  //Password confirmation
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (String? value) {
                      if (_passwordController.text != value) {
                        return 'Password not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  //Submit button
                  ElevatedButton(
                    onPressed: signupState.signupStatus == SignupStatus.submitting
                        ? null
                        : _submit,
                    child: Text(
                      signupState.signupStatus == SignupStatus.submitting
                          ? 'Submitting'
                          : 'Sign Up',
                    ),
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                      padding: const EdgeInsets.all(10.0),
                    ),
                  ),
                  const SizedBox(height: 15),
                  //Jump to Signin page button
                  TextButton(
                    onPressed: signupState.signupStatus == SignupStatus.submitting
                        ? null
                        : () =>
                        Navigator.pop(context),
                    child: const Text('Already a member? Sign In'),
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 20.0,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ].reversed.toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
