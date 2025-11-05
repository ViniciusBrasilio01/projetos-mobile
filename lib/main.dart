import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Importações das páginas

import 'package:aplicativo_nex/presentation/pages/crisis/crisis_mode_page.dart';
import 'package:aplicativo_nex/presentation/pages/tasks/task_page.dart';
import 'package:aplicativo_nex/presentation/pages/login/login_page.dart';
import 'package:aplicativo_nex/presentation/pages/register/register_page.dart';
import 'package:aplicativo_nex/presentation/pages/profile/profile_page.dart';


// Modelos Hive
import 'models/task.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Registro dos adapters Hive
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(UserProfileTypeAdapter());
  Hive.registerAdapter(UserAdapter());

  // Abertura das boxes
  await Hive.openBox<Task>('tasks');
  await Hive.openBox('auth');
  await Hive.openBox<User>('users');

  // Verifica se o usuário está logado
  final authBox = Hive.box('auth');
  final isLoggedIn = authBox.get('isLoggedIn', defaultValue: false);

  // Recupera o tipo de perfil armazenado (se houver)
  final int? profileIndex = authBox.get('profileType');
  final UserProfileType? profileType = profileIndex != null
      ? UserProfileType.values[profileIndex]
      : null;

  // Executa o aplicativo principal
  runApp(MyApp(isLoggedIn: isLoggedIn, profileType: profileType));
}

/// Widget principal do aplicativo
class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final UserProfileType? profileType;

  const MyApp({super.key, required this.isLoggedIn, required this.profileType});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NEX App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,

      // Define a rota inicial com base no login e perfil
      initialRoute: _getInitialRoute(),

      // Rotas nomeadas do aplicativo
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/': (context) => HomeScreen(),
        '/tasks': (context) => const TasksPage(),
        '/community': (context) => const SimpleScreen(title: 'Comunidade'),
        '/evolution': (context) => const SimpleScreen(title: 'Evolução'),
        '/education': (context) => const SimpleScreen(title: 'Educação'),
        '/support': (context) => const SimpleScreen(title: 'Suporte'),
        '/crisis': (context) => const CrisisModePage(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SimpleScreen(title: 'Configurações'),
      },
    );
  }

  /// Define a rota inicial com base no tipo de perfil
  String _getInitialRoute() {
    if (!isLoggedIn) return '/login';

    switch (profileType) {
      case UserProfileType.neurodivergente:
        return '/'; // Home padrão
      case UserProfileType.responsavel:
        return '/tasks'; // Exemplo: redireciona para tarefas
      case UserProfileType.profissional:
        return '/community'; // Exemplo: redireciona para comunidade
      default:
        return '/';
    }
  }
}

/// Tela principal exibida após login
class HomeScreen extends StatelessWidget {
  final double logoSize = 180;

  final List<MenuItem> menuItems = [
    MenuItem(icon: Icons.playlist_add_check, label: 'TAREFAS', route: '/tasks'),
    MenuItem(icon: Icons.forum, label: 'COMUNIDADE', route: '/community'),
    MenuItem(icon: Icons.show_chart, label: 'EVOLUÇÃO', route: '/evolution'),
    MenuItem(icon: Icons.school, label: 'EDUCAÇÃO', route: '/education'),
    MenuItem(icon: Icons.headset_mic, label: 'SUPORTE', route: '/support'),
    MenuItem(icon: Icons.warning, label: 'MODO CRISE', route: '/crisis'),
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double iconSize = logoSize * 0.33;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/logo_nex.png',
                  width: logoSize,
                  height: logoSize,
                  semanticLabel: 'Logo do aplicativo NEX',
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 1,
                      ),
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        final item = menuItems[index];
                        final bool isCrisis = item.label == 'MODO CRISE';

                        return Semantics(
                          label: 'Botão ${item.label}',
                          button: true,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isCrisis ? Colors.red : Colors.blue[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(16),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, item.route);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  item.icon,
                                  size: iconSize,
                                  color: isCrisis ? Colors.yellow : Colors.white,
                                  semanticLabel: item.label,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  item.label,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.person, color: Colors.blueAccent),
                tooltip: 'Perfil',
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.settings, color: Colors.blueAccent),
                tooltip: 'Configurações',
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Classe que representa um item do menu principal
class MenuItem {
  final IconData icon;
  final String label;
  final String route;

  MenuItem({required this.icon, required this.label, required this.route});
}

/// Tela genérica para páginas simples
class SimpleScreen extends StatelessWidget {
  final String title;

  const SimpleScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          'Tela de $title',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}