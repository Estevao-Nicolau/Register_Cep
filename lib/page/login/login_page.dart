import 'package:flutter/material.dart';
import 'package:register_cep/page/home/home_page.dart';
import 'package:register_cep/page/signup/signup_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Faça login na sua conta',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            // Campos de entrada de texto para nome de usuário e senha
            const TextField(
              decoration: InputDecoration(labelText: 'Nome de usuário'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true, // Para ocultar a senha
            ),
            const SizedBox(height: 20),
            // Botão de login
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 10),
            // Link para a página de cadastro
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignupPage(),
                  ),
                );
              },
              child: const Text('Não tem uma conta? Cadastre-se aqui'),
            ),
          ],
        ),
      ),
    );
  }
}
