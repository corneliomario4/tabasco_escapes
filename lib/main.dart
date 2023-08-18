import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:tabasco_escapes/pages/comunity_page.dart';
import 'package:tabasco_escapes/pages/home_page.dart';
import 'package:tabasco_escapes/pages/planner_page.dart';
import 'package:tabasco_escapes/pages/rutas.dart';
import 'firebase_options.dart';

import 'dart:io' show Platform;
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlayTab',
      theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 158, 30, 68),
          appBarTheme:
              const AppBarTheme(color: Color.fromARGB(255, 158, 30, 68))),
      initialRoute:
          FirebaseAuth.instance.currentUser != null ? "home" : "login",
      //initialRoute: "home",
      debugShowCheckedModeBanner: false,
      locale: const Locale('es'),
      localizationsDelegates: [
        FirebaseUILocalizations.withDefaultOverrides(const LabelOverrides()),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FirebaseUILocalizations.delegate
      ],
      routes: {
        "home": (context) => const HomePage(),
        "rutas": (context) => const Rutas(),
        "comunity": (context) => ComunityPage(),
        "planner": (context) => PlannerPage(),
        "profile": (context) => ProfileScreen(
              providers: [
                EmailAuthProvider(),
                GoogleProvider(
                    clientId:
                        Platform.isIOS ? "718367715543-ogp7nuj35gdgq67rg57r2atuubokmvkm.apps.googleusercontent.com" : "718367715543-k0ns3laihb1jnk9rpgs5lqos67oj08tp.apps.googleusercontent.com")
              ],
              actions: [
                SignedOutAction((context) {
                  Navigator.pushReplacementNamed(context, 'login');
                }),
              ],
              appBar: AppBar(
                title: const Text("Mi perfil"),
              ),
            ),
        "login": (context) => SignInScreen(
              providers: [
                EmailAuthProvider(),
                GoogleProvider(
                    clientId:
                        Platform.isIOS ? "718367715543-ogp7nuj35gdgq67rg57r2atuubokmvkm.apps.googleusercontent.com" : "718367715543-k0ns3laihb1jnk9rpgs5lqos67oj08tp.apps.googleusercontent.com")
              ],
              headerBuilder: (context, constraints, _) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset("assets/img/logo.png"),
                );
              },
              actions: [
                AuthStateChangeAction<SignedIn>((context, _) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Bienvendio ${FirebaseAuth.instance.currentUser?.displayName} !")));
                  Navigator.pushReplacementNamed(context, "home");
                }),
                AuthStateChangeAction<UserCreated>((context, _) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Bienvendio")));
                  Navigator.pushReplacementNamed(context, "home");
                })
              ],
            ),
      },
    );
  }
}

class LabelOverrides extends DefaultLocalizations {
  const LabelOverrides();

  @override
  String get emailInputLabel => "Ingresa tu Correo";

  @override
  String get signInText => "Iniciar Sesión";

  @override
  String get passwordInputLabel => "Ingresa tu contraseña";

  @override
  String get signInActionText => "Iniciar Sesion";

  @override
  String get registerActionText => "Registrate";

  @override
  String get signInWithGoogleButtonText => "Iniciar Sesión con Google";

  @override
  String get registerText => "Registrate";

  @override
  String get registerHintText => "¿No tienes cuenta?";

  @override
  String get signOutButtonText => "Cerrar sesión";

  @override
  String get deleteAccount => "Eliminar cuenta";

  @override
  String get forgotPasswordViewTitle => "¿Olvidaste tu contraseña?";

  @override
  String get forgotPasswordButtonLabel => "¿Olvidaste tu contraseña?";

  @override
  String get resetPasswordButtonLabel => "Reestablecer contraseña";

  @override
  String get forgotPasswordHintText =>
      "Ingresa tu correo electrónico y te enviaremos un correo con un enlace para reestabecer tu contraseña";

  @override
  String get goBackButtonLabel => "Regresar";

  @override
  String get confirmPasswordInputLabel => "Por favor, confirma tu contraseña";
}
