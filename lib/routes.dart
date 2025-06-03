// lib/routes.dart
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/principal_screen.dart';
import 'screens/cotacao_screen.dart';
import 'screens/transferencia_screen.dart';
import 'models/transferencia_args.dart';

class AppRoutes {
  static const String login = '/';
  static const String principal = '/principal';
  static const String cotacao = '/cotacao';
  static const String transferencia = '/transferencia';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case principal:
        return MaterialPageRoute(builder: (_) => PrincipalScreen());

      case cotacao:
        return MaterialPageRoute(builder: (_) => CotacaoScreen());

      case transferencia:
        final args = settings.arguments as TransferenciaArgs?;
        return MaterialPageRoute(
          builder: (_) => TransferenciaScreen(
            contaDestino: args?.contaDestino,
            valor: args?.valor,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Rota não encontrada: ${settings.name}')),
          ),
        );
    }
  }
}
