import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_turismo/model/ponto_turistico.dart';

class ConteudoFormDialog extends StatefulWidget {

  final PontoTuristico? pontoAtual;

  ConteudoFormDialog({Key? key, this.pontoAtual}) : super(key: key);

  @override
  ConteudoFormDialogState createState() => ConteudoFormDialogState();

}

class ConteudoFormDialogState extends State<ConteudoFormDialog> {

  final formKey = GlobalKey<FormState>();
  final descricaoController = TextEditingController();
  final nomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.pontoAtual != null) {
      descricaoController.text = widget.pontoAtual!.descricao;
      nomeController.text = widget.pontoAtual!.nome;
    }
  }

  Widget build(BuildContext context) {

    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: nomeController,
            decoration: InputDecoration(labelText: 'Nome'),
            validator: (String? valor) {
              if(valor == null || valor.isEmpty) {
                return 'Informe o nome do ponto turístico';
              }
              return null;
            },
          ),
          TextFormField(
            controller: descricaoController,
            decoration: InputDecoration(labelText: 'Descrição'),
            validator: (String? valor) {
              if(valor == null || valor.isEmpty) {
                return 'Informe uma descrição';
              }
              return null;
            },
          )
        ],
      ),
    );
  }

  bool dadosValidados() => formKey.currentState!.validate() == true;

  PontoTuristico get novoPonto => PontoTuristico(
      id: widget.pontoAtual?.id ?? 0,
      nome: nomeController.text,
      descricao: descricaoController.text,
      cadastro: DateTime.now()
  );

}