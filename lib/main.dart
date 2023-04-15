import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_application_4/providers/simulacion_provider.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_4/providers/cliente_provider.dart';
import 'package:flutter_application_4/providers/test_provider.dart';
import 'package:flutter_application_4/providers/text_controller.dart';
import 'package:flutter_application_4/providers/utilities_provideer.dart';
import 'package:flutter_application_4/screens/navigation_screen.dart';

import 'models/calculate_model.dart';

void main() {
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (__) => TestProvider()),
        ChangeNotifierProvider(create: (__) => Calculo()),
        ChangeNotifierProvider(create: (__) => ClienteProvider()),
        ChangeNotifierProvider(
            create: (__) => TextEditingControllerProvideer()),
        ChangeNotifierProvider(create: (__) => UtilitiesProvider()),
        ChangeNotifierProvider(create: (__) => SimulacionProvider()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const FluentApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(
        //     scaffoldBackgroundColor: Colors.white,
        //     accentColor: Colors.blue,
        //     iconTheme: const IconThemeData(size: 24)),
        // darkTheme: ThemeData(
        //     scaffoldBackgroundColor: Colors.black,
        //     accentColor: Colors.blue,
        //     iconTheme: const IconThemeData(size: 24)),
        //home: const MyHomePage(title: 'Flutter Demo Home Page'),
        home: NavigationViewPage());
  }
}
