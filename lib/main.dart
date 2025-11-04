import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Importações das páginas principais
import 'package:aplicativo_nex/presentation/pages/crisis/crisis_mode_page.dart';
import 'package:aplicativo_nex/presentation/pages/tasks/task_page.dart';
import 'package:aplicativo_nex/presentation/pages/login/login_page.dart';
import 'package:aplicativo_nex/presentation/pages/register/register_page.dart';

// Importações dos modelos Hive
import 'models/task.dart';
import 'models/user.dart';

void main() async {
  // Inicializa o Flutter antes de qualquer operação assíncrona
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Hive com suporte ao Flutter
  await Hive.initFlutter();

  // Registra os adapters dos modelos Hive
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(UserProfileTypeAdapter());
  Hive.registerAdapter(UserAdapter());

  // Abre as caixas Hive utilizadas no app
  await Hive.openBox<Task>('tasks'); // Caixa de tarefas
  await Hive.openBox('auth');        // Caixa de autenticação
  await Hive.openBox<User>('users'); // Caixa de usuários

  // Verifica se o usuário está logado
  final isLoggedIn = Hive.box('auth').get('isLoggedIn', defaultValue: false);

  // Executa o aplicativo principal
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

/// Widget principal do aplicativo
class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NEX App',
      debugShowCheckedModeBanner: false,

      // Define temas claro e escuro
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,

      // Define a rota inicial com base no estado de login
      initialRoute: isLoggedIn ? '/' : '/login',

      // Define todas as rotas nomeadas do aplicativo
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
        '/profile': (context) => const SimpleScreen(title: 'Perfil'),
        '/settings': (context) => const SimpleScreen(title: 'Configurações'),
      },
    );
  }
}

/// Tela principal exibida após login
class HomeScreen extends StatelessWidget {
  final double logoSize = 180;

  // Lista de itens do menu principal
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

                // Logo do aplicativo
                Image.asset(
                  'assets/images/logo_nex.png',
                  width: logoSize,
                  height: logoSize,
                  semanticLabel: 'Logo do aplicativo NEX',
                ),

                const SizedBox(height: 20),

                // Grade de botões do menu
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

            // Botão de acesso ao perfil
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

            // Botão de acesso às configurações
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