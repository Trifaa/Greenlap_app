import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greenlab_app/home.dart';
import 'dart:convert';
import 'package:greenlab_app/style/style_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _StateLogin();
}

class _StateLogin extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email == 'admin123@gmail.com' && password == 'admin123') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Login exitoso!')),
      );
       Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
    } else {
      _showErrorDialog('Credenciales incorrectas');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alerta'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return DefaultTextStyle(
        style: TextStyle(fontSize: 14.sp),
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Center(
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GreenLabLogo(),
                  TextFormField(
                    style: TextStyle(color: colorScheme.onSurface),
                    controller: _emailController,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: colorScheme.primary, width: 1),
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: colorScheme.primary, width: 2)),
                        labelText: 'Correo',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: colorScheme.primary,
                        )),
                  ),
                  SizedBox(height: 10.h),
                  PasswordField(controller: _passwordController),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.primary,
                      ),
                      child: const Text('¿Olvidaste tu contraseña?'),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 18),
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary),
                        child: const Text('Ingresar')),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No tienes cuenta?',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface)),
                      TextButton(
                          onPressed: () {
                            // Aquí iría la navegación al registro
                          },
                          child: const Text(
                            'Registrate',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ],
              )),
            ),
          ),
        ));
  }
}