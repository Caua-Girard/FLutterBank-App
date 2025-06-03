// lib/screens/transferencia_screen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class TransferenciaScreen extends StatefulWidget {
  final String? contaDestino;
  final double? valor;

  const TransferenciaScreen({
    Key? key,
    this.contaDestino,
    this.valor,
  }) : super(key: key);

  @override
  _TransferenciaScreenState createState() => _TransferenciaScreenState();
}

class _TransferenciaScreenState extends State<TransferenciaScreen> {
  late TextEditingController _contaController;
  late TextEditingController _valorController;
  XFile? _imagemSelecionada;
  bool _submetendo = false;

  @override
  void initState() {
    super.initState();
    // Inicializa controllers com valores vindos dos argumentos, se existirem
    _contaController = TextEditingController(text: widget.contaDestino ?? '');
    _valorController = TextEditingController(
      text: widget.valor != null ? widget.valor!.toStringAsFixed(2) : '',
    );
  }

  @override
  void dispose() {
    _contaController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  Future<void> _selecionarImagem(bool daCamera) async {
    // Solicita permissão de câmera (necessário para câmera)
    if (daCamera) {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permissão de câmera negada')),
        );
        return;
      }
    }
    // Para galeria, em Android 13+ pode usar Permission.photos; em Android < 13, READ_EXTERNAL_STORAGE
    final statusGaleria = await Permission.photos.request();
    if (!statusGaleria.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permissão de acesso à galeria negada')),
      );
      return;
    }

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: daCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (picked != null) {
      setState(() {
        _imagemSelecionada = picked;
      });
    }
  }

  Future<void> _efetuarTransferencia() async {
    final conta = _contaController.text.trim();
    final valorText = _valorController.text.trim().replaceAll(',', '.');
    final valor = double.tryParse(valorText) ?? 0.0;

    if (conta.isEmpty || valor <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Informe conta destino e valor válido')),
      );
      return;
    }

    setState(() {
      _submetendo = true;
    });

    // Simula delay de chamada a serviço
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _submetendo = false;
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Transferência realizada'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('R\$ ${valor.toStringAsFixed(2)} enviados para $conta'),
            if (_imagemSelecionada != null) ...[
              SizedBox(height: 16),
              Text('Comprovante:'),
              SizedBox(height: 8),
              Image.file(
                File(_imagemSelecionada!.path),
                height: 150,
                fit: BoxFit.cover,
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // fecha o diálogo
              Navigator.popUntil(
                context,
                ModalRoute.withName('/principal'),
              );
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Transferência'),
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              children: [
                Text(
                  'Dados da Transferência',
                  style: theme.textTheme.titleLarge,
                ),
                SizedBox(height: 24),

                // Campo de conta destino
                TextFormField(
                  controller: _contaController,
                  decoration: InputDecoration(
                    labelText: 'Conta Destino',
                    prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                  ),
                  validator: (val) =>
                  val == null || val.isEmpty ? 'Informe a conta' : null,
                ),
                SizedBox(height: 16),

                // Campo de valor
                TextFormField(
                  controller: _valorController,
                  decoration: InputDecoration(
                    labelText: 'Valor (R\$)',
                    prefixIcon: Icon(Icons.attach_money_outlined),
                  ),
                  keyboardType:
                  TextInputType.numberWithOptions(decimal: true),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Informe o valor';
                    final n = num.tryParse(val.replaceAll(',', '.'));
                    if (n == null || n <= 0) return 'Valor inválido';
                    return null;
                  },
                ),
                SizedBox(height: 24),

                // Botões para câmera e galeria
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.camera_alt),
                      label: Text('Câmera'),
                      onPressed: () => _selecionarImagem(true),
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.photo),
                      label: Text('Galeria'),
                      onPressed: () => _selecionarImagem(false),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Pré-visualização da imagem, se selecionada
                if (_imagemSelecionada != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(_imagemSelecionada!.path),
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 24),
                ],

                // Botão de enviar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submetendo ? null : _efetuarTransferencia,
                    child: _submetendo
                        ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                        AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                        : Text('Enviar Transferência'),
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
