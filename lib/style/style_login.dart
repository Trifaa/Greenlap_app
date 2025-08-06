import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class PasswordField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordField({Key? key, required this.controller}) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      style: TextStyle(color: colorScheme.onSurface),
      controller: widget.controller,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary, width: 1.w),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary, width: 2.w),
        ),
        labelText: 'Contraseña',
        prefixIcon: Icon(
          Icons.lock_outline,
          color: colorScheme.primary,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isObscure ? Icons.visibility : Icons.visibility_off,
            color: colorScheme.primary,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
      ),
      obscureText: _isObscure, 
    );
  }
}

class GreenLabLogo extends StatelessWidget {
  const GreenLabLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset( 'assets/greenlab.jpg', height: 150, width: 150,);
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}


class EstadoEtiqueta extends StatelessWidget {
  final String estado;

  const EstadoEtiqueta({super.key, required this.estado});

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color backgroundColor;
    Color borderColor;

    switch (estado.toLowerCase()) {
      case 'en uso':
        textColor = const Color(0xFFB8860B); // amarillo oscuro
        backgroundColor = const Color(0xFFFFF9C4); // amarillo claro
        borderColor = const Color(0xFFB8860B);
        break;
      case 'disponible':
        textColor = const Color(0xFF2E7D32); // verde oscuro
        backgroundColor = const Color(0xFFC8E6C9); // verde claro
        borderColor = const Color(0xFF2E7D32);
        break;
      case 'malogrado':
        textColor = const Color(0xFFB71C1C); // rojo oscuro
        backgroundColor = const Color(0xFFFFCDD2); // rojo claro
        borderColor = const Color(0xFFB71C1C);
        break;
      default:
        textColor = Colors.grey;
        backgroundColor = Colors.grey.shade200;
        borderColor = Colors.grey;
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          estado,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}