import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Crie uma nova conta',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            // Campos de entrada de texto para registro
            const TextField(
              decoration: InputDecoration(labelText: 'Nome de usuário'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            // Botão de cadastro
            ElevatedButton(
              onPressed: () {
                // Adicione aqui a lógica de criação de conta
              },
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}