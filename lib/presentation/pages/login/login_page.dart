import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:collection/collection.dart';
import '/models/user.dart';

/// Tela de login do aplicativo
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  /// Função responsável por autenticar o usuário
  void _login() {
    if (_formKey.currentState!.validate()) {
      final usersBox = Hive.box<User>('users');
      final authBox = Hive.box('auth');
      final username = _usernameController.text.trim();
      final password = _passwordController.text;

      // Busca o usuário com nome e senha correspondentes
      User? user = usersBox.values.firstWhereOrNull(
        (u) => u.username == username && u.password == password,
      );

      if (user != null) {
        // Armazena estado de login e tipo de perfil na box 'auth'
        authBox.put('isLoggedIn', true);
        authBox.put('profileType', user.profileType.index); // Salva como inteiro

        // Redireciona para a rota inicial definida no main.dart
        Navigator.pushReplacementNamed(context, '/');
      } else {
        // Exibe mensagem de erro se credenciais forem inválidas
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário ou senha inválidos')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Impede que o usuário volte para a tela anterior
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          automaticallyImplyLeading: false, // Remove botão de voltar
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Campo de entrada para nome de usuário
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Usuário'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Informe o usuário' : null,
                ),

                // Campo de entrada para senha
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Informe a senha' : null,
                ),

                const SizedBox(height: 20),

                // Botão para realizar login
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Entrar'),
                ),

                // Botão para navegar para a tela de cadastro
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: const Text('Criar conta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}