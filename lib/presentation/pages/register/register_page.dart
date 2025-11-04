import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../models/user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Variável para armazenar o tipo de perfil selecionado
  UserProfileType? _selectedProfile;

  /// Função para realizar o cadastro do usuário
  void _register() {
    if (_formKey.currentState!.validate() && _selectedProfile != null) {
      final usersBox = Hive.box<User>('users');
      final username = _usernameController.text.trim();
      final password = _passwordController.text;

      // Verifica se o usuário já existe
      if (usersBox.values.any((user) => user.username == username)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário já existe')),
        );
      } else {
        // Cria e salva o novo usuário
        final newUser = User(
          username: username,
          password: password,
          profileType: _selectedProfile!,
        );
        usersBox.add(newUser);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadastro realizado com sucesso')),
        );
        Navigator.pop(context);
      }
    } else if (_selectedProfile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione o tipo de perfil')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo de usuário
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Usuário'),
                validator: (value) => 
                  value == null || value.isEmpty ? 'Informe o usuário' : null,
              ),
              const SizedBox(height: 12),

              // Campo de senha
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) =>
                  value == null || value.isEmpty ? 'Informe a senha' : null,
              ),
              const SizedBox(height: 12),

              // Campo de confirmação de senha
              TextFormField(
                controller: _confirmController,
                decoration: const InputDecoration(labelText: 'Confirmar senha'),
                obscureText: true,
                validator: (value) =>
                  value != _passwordController.text ? 'Senhas não conferem' : null,
              ),
              const SizedBox(height: 20),

              // Seleção de tipo de perfil
              const Text('Selecione seu perfil:', style: TextStyle(fontWeight: FontWeight.bold)),
              ListTile(
                title: const Text('Neurodivergente'),
                leading: Radio<UserProfileType>(
                  value: UserProfileType.neurodivergente,
                  groupValue: _selectedProfile,
                  onChanged: (value) => setState(() => _selectedProfile = value),
                ),
              ),
              ListTile(
                title: const Text('Pai/Responsável'),
                leading: Radio<UserProfileType>(
                  value: UserProfileType.responsavel,
                  groupValue: _selectedProfile,
                  onChanged: (value) => setState(() => _selectedProfile = value),
                ),
              ),
              ListTile(
                title: const Text('Profissional (Médico ou Professor)'),
                leading: Radio<UserProfileType>(
                  value: UserProfileType.profissional,
                  groupValue: _selectedProfile,
                  onChanged: (value) => setState(() => _selectedProfile = value),
                ),
              ),
              const SizedBox(height: 20),

              // Botão de cadastro
              ElevatedButton(
                onPressed: _register,
                child: const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}