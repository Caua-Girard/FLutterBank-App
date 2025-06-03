import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';      // <— importar o share_plus
import '../models/CotacaoServices.dart';

class CotacaoScreen extends StatefulWidget {
  @override
  _CotacaoScreenState createState() => _CotacaoScreenState();
}

class _CotacaoScreenState extends State<CotacaoScreen> {
  final List<String> _moedas = ['USD', 'EUR', 'BTC'];
  String _selectedCurrency = 'USD';
  String _cotacaoTexto = '';
  bool _loading = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _buscarCotacaoReal();
  }

  Future<void> _buscarCotacaoReal() async {
    setState(() {
      _loading = true;
      _erro = null;
    });

    final valor = await CotacaoService.buscarCotacao(_selectedCurrency);

    if (valor != null) {
      setState(() {
        _cotacaoTexto =
        '1 $_selectedCurrency = R\$ ${valor.toStringAsFixed(2)}';
        _loading = false;
      });
    } else {
      setState(() {
        _erro = 'Não foi possível obter a cotação.';
        _loading = false;
      });
    }
  }

  void _compartilharCotacao() {
    if (_cotacaoTexto.isNotEmpty && !_loading && _erro == null) {
      Share.share('Cotação $_selectedCurrency/BRL:\n$_cotacaoTexto');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cotação de Moeda'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Título e Dropdown (igual antes)...
                Text(
                  'Cotação ${_selectedCurrency}/BRL',
                  style: theme.textTheme.titleLarge,
                ),
                SizedBox(height: 16),
                DropdownButton<String>(
                  value: _selectedCurrency,
                  icon: Icon(Icons.arrow_drop_down, color: theme.primaryColor),
                  elevation: 16,
                  style: theme.textTheme.bodyMedium,
                  underline: Container(
                    height: 2,
                    color: theme.primaryColor,
                  ),
                  onChanged: (String? newValue) {
                    if (newValue != null && newValue != _selectedCurrency) {
                      setState(() {
                        _selectedCurrency = newValue;
                      });
                      _buscarCotacaoReal();
                    }
                  },
                  items: _moedas.map<DropdownMenuItem<String>>((String moeda) {
                    return DropdownMenuItem<String>(
                      value: moeda,
                      child: Text(moeda),
                    );
                  }).toList(),
                ),
                SizedBox(height: 24),

                // Área de carregamento / erro / resultado:
                if (_loading) ...[
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Carregando...',
                    style: theme.textTheme.bodyMedium,
                  ),
                ] else if (_erro != null) ...[
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  SizedBox(height: 16),
                  Text(
                    _erro!,
                    style:
                    theme.textTheme.bodyMedium!.copyWith(color: Colors.red),
                  ),
                ] else ...[
                  // Exibe o texto da cotação e o ícone de compartilhamento
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _cotacaoTexto,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.share, color: theme.primaryColor),
                        onPressed: _compartilharCotacao,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                ],

                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.refresh),
                    label: Text('Atualizar'),
                    onPressed: _buscarCotacaoReal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
