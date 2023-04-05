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

  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _nomeController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    if(widget.pontoAtual != null) {
      _descricaoController.text = widget.pontoAtual!.descricao;
      _nomeController.text = widget.pontoAtual!.nome;
    }
  }

  Widget build(BuildContext context) {

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nomeController,
            decoration: InputDecoration(labelText: 'Nome'),
            validator: (String? valor) {
              if(valor == null || valor.isEmpty) {
                return 'Informe o nome do ponto turístico';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _descricaoController,
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

  bool dadosValidados() => _formKey.currentState!.validate() == true;

  PontoTuristico get novoPonto => PontoTuristico(
      id: widget.pontoAtual?.id,
      nome: _nomeController.text,
      descricao: _descricaoController.text,
      //cadastro: _dateFormat.parse(DateTime.now().toString())
  );

}