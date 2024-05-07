import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rhythm_reveal/page_home.dart';
import 'package:rhythm_reveal/globals.dart' as globals;

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String username = '';
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void authenticate() async {
    if (_signInFormKey.currentState!.validate()) {
      _signInFormKey.currentState!.save();
      var collection = FirebaseFirestore.instance.collection('users');
      var querySnapshot = await collection
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userDoc = querySnapshot.docs.first;
        globals.currentUser = email;
        globals.username = userDoc.data()['username'] as String;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        _showDialog('Login Failed',
            'No user found with that email and password. Please try again.');
      }
    }
  }

  void signUp() async {
    if (_signUpFormKey.currentState!.validate()) {
      _signUpFormKey.currentState!.save();
      var collection = FirebaseFirestore.instance.collection('users');
      var querySnapshot =
          await collection.where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isEmpty) {
        Map<String, dynamic> userData = {
          'username': username,
          'email': email,
          'password': password,
          'topThree': [],
          'fullHistory': []
        };

        await collection.add(userData);
        globals.currentUser = email;
        globals.username = userData['username'];
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        _showDialog(
            'Sign Up Failed', 'An account with this email already exists.');
      }
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
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
        title: Text('Authentication'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Sign In'),
            Tab(text: 'Sign Up'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildSignInForm(),
          buildSignUpForm(),
        ],
      ),
    );
  }

  Widget buildSignInForm() {
    return Form(
      key: _signInFormKey,
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
    );
  }

  Widget buildSignUpForm() {
    return Form(
      key: _signUpFormKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Username'),
              onSaved: (value) => username = value!,
            ),
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
              onPressed: signUp,
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
