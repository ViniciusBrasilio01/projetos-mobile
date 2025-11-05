import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../models/user.dart';

/// Tela de perfil do usuário logado
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  /// Função que retorna o nome legível do tipo de perfil
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

  /// Função que realiza o logout do usuário
  void _logout(BuildContext context) {
    final authBox = Hive.box('auth');
    authBox.put('isLoggedIn', false);
    authBox.delete('profileType');

    // Retorna à tela de login
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final authBox = Hive.box('auth');
    final usersBox = Hive.box<User>('users');

    // Recupera o tipo de perfil armazenado
    final int? profileIndex = authBox.get('profileType');
    final UserProfileType? profileType = profileIndex != null
        ? UserProfileType.values[profileIndex]
        : null;

    // Recupera o usuário logado com base no tipo de perfil
    final User? currentUser = usersBox.values.firstWhere(
      (user) => user.profileType == profileType,
      
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        automaticallyImplyLeading: false, // Remove botão de voltar
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: currentUser == null
            ? const Center(child: Text('Usuário não encontrado'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Ícone de perfil
                  const Center(
                    child: Icon(Icons.account_circle, size: 100, color: Colors.blueAccent),
                  ),

                  const SizedBox(height: 20),

                  // Nome de usuário
                  Text(
                    'Usuário:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    currentUser.username,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  const SizedBox(height: 20),

                  // Tipo de perfil
                  Text(
                    'Tipo de Perfil:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    _getProfileLabel(currentUser.profileType),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  const Spacer(),

                  // Botão de logout
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.logout),
                      label: const Text('Sair'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => _logout(context),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}