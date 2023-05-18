import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:projeto_turismo/model/ponto_turistico.dart';

class ConteudoFormDialog extends StatefulWidget {

  final PontoTuristico? pontoAtual;

  ConteudoFormDialog({Key? key, this.pontoAtual}) : super(key: key);

  @override
  ConteudoFormDialogState createState() => ConteudoFormDialogState();

}

class ConteudoFormDialogState extends State<ConteudoFormDialog> {

  Position? _localizacaoAtual;
  double? longitude;
  double? latitude;

  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _nomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.pontoAtual != null) {
      _descricaoController.text = widget.pontoAtual!.descricao;
      _nomeController.text = widget.pontoAtual!.nome;
      longitude = widget.pontoAtual!.longitude;
      latitude = widget.pontoAtual!.latitude;
    } else {
      _obterLocalizacaoAtual();
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
      cadastro: DateTime.now(),
      longitude: _localizacaoAtual?.longitude ?? longitude,
      latitude: _localizacaoAtual?.latitude ?? latitude
  );

  void _obterLocalizacaoAtual() async {
    bool servicoHabilitado = await _servicoHabilitado();
    if(!servicoHabilitado){
      return;
    }

    bool permissoesPermitidas = await _permissoesPermitidas();
    if(!permissoesPermitidas){
      return;
    }

    _localizacaoAtual = await Geolocator.getCurrentPosition();
    setState(() {

    });
  }

  Future<bool> _servicoHabilitado() async {
    bool servicoHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicoHabilitado){
      await _mostrarDialogMensagem('Para utilizar esse recurso, você deverá habilitar o serviço'
          ' de localização');
      Geolocator.openLocationSettings();
      return false;
    }
    return true;
  }

  Future<bool> _permissoesPermitidas() async {
    LocationPermission permissao = await Geolocator.checkPermission();
    if(permissao == LocationPermission.denied){
      permissao = await Geolocator.requestPermission();
      if(permissao == LocationPermission.denied){
        _mostrarMensagem('Não será possível utilizar o recurso '
            'por falta de permissão');
      }
    }
    if(permissao == LocationPermission.deniedForever){
      await _mostrarDialogMensagem('Para utilizar esse recurso, você deverá acessar '
          'as configurações do app para permitir a utilização do serviço de localização');
      Geolocator.openAppSettings();
      return false;
    }
    return true;
  }

  void _mostrarMensagem(String mensagem){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Future<void> _mostrarDialogMensagem(String mensagem) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Atenção'),
        content: Text(mensagem),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK')
          )
        ],
      ),
    );
  }

}