import 'dart:developer';

import 'package:apiadmin/blocs/signin/sign_in_bloc.dart';
import 'package:apiadmin/pages/home_page.dart';
import 'package:apiadmin/utils/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20.0),
          width: 400.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: email,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: password,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20.0),
              BlocListener<SignInBloc, SignInState>(
                listener: (context, state) {
                  switch (state.runtimeType) {
                    case SignInSuccess:
                      print(Tokens.token);
                      print('token printed');

                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomePage()));

                    case SignInFailed:
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Try again')));

                    case SignInLoading:
                      log('this is signin loading state');

                    default:
                      log('this is default state');
                  }
                },
                child: ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<SignInBloc>(context).add(OnSignInEvent(
                        userName: email.text, password: password.text));
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}
