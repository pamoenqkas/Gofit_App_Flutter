import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'MemberPage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      routes: {
    '/member': (context) => MemberPage(idMember: 'idMemberValue'), // Ganti 'idMemberValue' dengan nilai yang sesuai
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  late BuildContext _loginScreenContext; // Menyimpan objek BuildContext dari LoginScreen

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loginScreenContext = context; // Simpan objek BuildContext saat didChangeDependencies dipanggil
  }
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    var url = Uri.parse('https://pam.ppcdeveloper.com/api/login');
    var response = await http.post(url, body: {'email': email, 'password': password});

    if (response.statusCode == 200) {
       var data = jsonDecode(response.body); // Mendekode respons API menjadi objek Dart
      var id = data['id']; // Memperoleh nilai id dari respons API

      Navigator.push(
        _loginScreenContext,
        MaterialPageRoute(
          builder: (context) => MemberPage(idMember: id!), // Menggunakan nilai id yang diperoleh
        ),
      );
      
    } else {
      // Handle kesalahan saat login
      print('Login failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
