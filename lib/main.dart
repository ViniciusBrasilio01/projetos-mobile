import 'package:flutter/material.dart';
import 'package:aplicativo_nex/presentation/pages/crisis/crisis_mode_page.dart'; // Importação da tela do Modo Crise
import 'package:aplicativo_nex/presentation/pages/tasks/task_page.dart'; // Importação da tela de tarefas
import 'package:aplicativo_nex/presentation/pages/login/login_page.dart'; // Importação da tela de login
import 'package:aplicativo_nex/presentation/pages/register/register_page.dart'; // Importação da tela de registro
import 'package:hive_flutter/hive_flutter.dart';
import 'models/task.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasks');
  await Hive.openBox('auth'); // nova box para autenticação

  final isLoggedIn = Hive.box('auth').get('isLoggedIn', defaultValue: false);

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NEX App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      initialRoute: isLoggedIn ? '/' : '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/': (context) => HomeScreen(),
        '/tasks': (context) => TasksPage(),
        '/community': (context) => SimpleScreen(title: 'Comunidade'),
        '/evolution': (context) => SimpleScreen(title: 'Evolução'),
        '/education': (context) => SimpleScreen(title: 'Educação'),
        '/support': (context) => SimpleScreen(title: 'Suporte'),
        '/crisis': (context) => CrisisModePage(),
        '/profile': (context) => SimpleScreen(title: 'Perfil'),
        '/settings': (context) => SimpleScreen(title: 'Configurações'),
      },
    );
  }
}

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
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
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

class MenuItem {
  final IconData icon;
  final String label;
  final String route;

  MenuItem({required this.icon, required this.label, required this.route});
}

class SimpleScreen extends StatelessWidget {
  final String title;

  const SimpleScreen({required this.title});

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