import 'package:flutter/material.dart';
import 'package:register_cep/page/home/home_page.dart';
import 'package:register_cep/page/signup/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _showPassword = false; // Variável para controlar a visibilidade da senha

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Bem Vindo',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            // Campo de entrada de texto para nome de usuário
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Nome de usuário',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  prefixIcon: const Icon(Icons.person), // Ícone personalizado
                ),
              ),
            ),
            // Campo de entrada de texto para senha
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  prefixIcon: const Icon(Icons.lock), // Ícone personalizado
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      // Alternar a visibilidade da senha e atualizar a interface
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                ),
                obscureText: !_showPassword, // Para ocultar a senha
              ),
            ),
            const SizedBox(height: 20),
            // Botão de login
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
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
