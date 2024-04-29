import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:rhythm_reveal/page_home.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final String response = await rootBundle.loadString('assets/users.json');
    final data = json.decode(response);
    setState(() {
      users = data;
    });
  }

  void authenticate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var existingUser = users.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
        orElse: () => null
      );

      if (existingUser != null) {
        print('Login Successful');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        print('User not found or password incorrect');
        // Optionally show an error message
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Login Failed'),
            content: Text('No user found with that email and password. Please try again.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onSaved: (value) => email = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (value) => password = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: authenticate,
                child: Text('Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
