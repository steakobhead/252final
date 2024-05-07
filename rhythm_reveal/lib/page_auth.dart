import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rhythm_reveal/page_home.dart';
import 'package:rhythm_reveal/globals.dart' as globals;

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
  }

  void authenticate() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        var collection = FirebaseFirestore.instance.collection('users');
        var querySnapshot = await collection
            .where('email', isEqualTo: email)
            .where('password', isEqualTo: password)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          globals.currentUser = email;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          _showLoginFailedDialog();
        }
      } catch (e) {
        _showLoginFailedDialog();
      }
    }
  }

  void _showLoginFailedDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Login Failed'),
        content: Text(
            'No user found with that email and password. Please try again.'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
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
