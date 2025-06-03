import 'package:flutter/material.dart';
import '../routes.dart';
import '../models/transferencia_args.dart';

class PrincipalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Valores de exemplo para demonstrar passagem de argumentos
    final exemploConta = '123456789';
    final exemploValor = 250.00;

    return Scaffold(
      appBar: AppBar(
        title: Text('Banco Digital'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          children: [
            Text(
              'Menu Principal',
              style: theme.textTheme.titleLarge,
            ),
            SizedBox(height: 24),

            // Card para "Ver Cotação"
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.monetization_on,
                    color: theme.primaryColor),
                title: Text('Ver Cotação', style: theme.textTheme.bodyMedium),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.cotacao);
                },
              ),
            ),
            SizedBox(height: 12),

            // Card para "Fazer Transferência"
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.send, color: theme.primaryColor),
                title: Text('Fazer Transferência',
                    style: theme.textTheme.bodyMedium),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  final args = TransferenciaArgs(
                    contaDestino: exemploConta,
                    valor: exemploValor,
                  );
                  Navigator.pushNamed(
                    context,
                    AppRoutes.transferencia,
                    arguments: args,
                  );
                },
              ),
            ),
            Spacer(),

            // Botão de logout
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.logout),
                label: Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
