import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/user.dart';

/// Tela de perfil com edição de nome e imagem
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  String? _imagePath;

  /// Retorna o nome legível do tipo de perfil
  String _getProfileLabel(UserProfileType type) {
    switch (type) {
      case UserProfileType.neurodivergente:
        return 'Neurodivergente';
      case UserProfileType.responsavel:
        return 'Pai/Responsável';
      case UserProfileType.profissional:
        return 'Profissional (Médico ou Professor)';
    }
  }

  /// Realiza logout e limpa dados da box 'auth'
  void _logout() {
    final authBox = Hive.box('auth');
    authBox.put('isLoggedIn', false);
    authBox.delete('profileType');

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  /// Atualiza os dados do usuário no Hive
  void _saveChanges(User user) {
    if (_formKey.currentState!.validate()) {
      user.username = _usernameController.text.trim();
      user.profileImagePath = _imagePath;
      user.save();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso')),
      );
    }
  }

  /// Abre o seletor de imagem e salva o caminho
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _imagePath = picked.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authBox = Hive.box('auth');
    final usersBox = Hive.box<User>('users');

    final int? profileIndex = authBox.get('profileType');
    final UserProfileType? profileType = profileIndex != null
        ? UserProfileType.values[profileIndex]
        : null;

    final User? currentUser = usersBox.values.firstWhere(
      (user) => user.profileType == profileType,
    );

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Usuário não encontrado')),
      );
    }

    // Preenche os campos com dados atuais
    _usernameController.text = currentUser.username;
    _imagePath ??= currentUser.profileImagePath;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),

              // Imagem de perfil
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _imagePath != null
                        ? FileImage(File(_imagePath!))
                        : const AssetImage('assets/images/default_avatar.png')
                            as ImageProvider,
                    child: _imagePath == null
                        ? const Icon(Icons.camera_alt, size: 30, color: Colors.white)
                        : null,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Campo de edição do nome de usuário
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Nome de usuário'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o nome' : null,
              ),

              const SizedBox(height: 20),

              // Tipo de perfil (somente leitura)
              Text(
                'Tipo de Perfil:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                _getProfileLabel(currentUser.profileType),
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              const SizedBox(height: 30),

              // Botão para salvar alterações
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Salvar Alterações'),
                onPressed: () => _saveChanges(currentUser),
              ),

              const SizedBox(height: 20),

              // Botão para logout
              ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Sair'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: _logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}