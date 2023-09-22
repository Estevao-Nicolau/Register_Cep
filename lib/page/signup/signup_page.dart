import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key, });

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _showPassword = false; // Variável para controlar a visibilidade da senha

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
            // Campo de entrada de texto para email
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  prefixIcon: const Icon(Icons.email), // Ícone personalizado
                ),
              ),
            ),
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
