import 'package:firebase_app_provider/models/custom_error.dart';
import 'package:firebase_app_provider/pages/pages.dart';
import 'package:firebase_app_provider/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';
import '../providers/providers.dart';


class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);
  static const String routeName = '/signin';

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String? _email, _password;

  Future<void> _submit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;
    if (form == null && !form!.validate()) return;

    form.save();

    try {
      await context
          .read<SigninProvider>()
          .signin(email: _email!, password: _password!);
    } on CustomError catch (e) {
      errorDialog(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final signinState = context.watch<SigninProvider>().state;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          //resizeToAvoidBottomInset: false,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formKey,
                autovalidateMode: _autovalidateMode,
                child: ListView(
                  shrinkWrap: true,
                  reverse: true,
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
                      autocorrect: false,
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
                    //Sign in button
                    ElevatedButton(
                      onPressed: signinState.signinStatus == SigninStatus.submitting
                          ? null
                          : _submit,
                      child: Text(
                        signinState.signinStatus == SigninStatus.submitting
                            ? 'Submitting'
                            : 'Sign In',
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
                    //Jump to Signup page button
                    TextButton(
                      onPressed: signinState.signinStatus == SigninStatus.submitting
                          ? null
                          : () =>
                              Navigator.pushNamed(context, SignupPage.routeName),
                      child: const Text('Not a member? Sign up'),
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
      ),
    );
  }
}
