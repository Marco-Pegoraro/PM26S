import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:projeto_turismo/model/ponto_turistico.dart';

class DetalhesPontoPage extends StatefulWidget {

  final PontoTuristico pontoTuristico;

  const DetalhesPontoPage({Key? key, required this.pontoTuristico}) : super(key: key);

  @override
  _DetalhesPontoPageState createState() => _DetalhesPontoPageState();
}

class _DetalhesPontoPageState extends State<DetalhesPontoPage> {

  Position? _localizacaoAtual;

  @override
  void initState() {
    super.initState();
    _obterLocalizacaoAtual();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Ponto Turístico'),
      ) ,
      body: _criaBody() ,
    );
  }

  Widget _criaBody(){
    return Padding(
      padding: EdgeInsets.all(10),
      child: ListView(
        children: [
          Row(
            children: [
              Campo(descricao:'Código: '),
              Valor(valor: '${widget.pontoTuristico.id}'),
            ],
          ),
          Row(
            children: [
              Campo(descricao:'Nome: '),
              Valor(valor: '${widget.pontoTuristico.nome}'),
            ],
          ),
          Row(
            children: [
              Campo(descricao:'Descrição: '),
              Valor(valor: '${widget.pontoTuristico.descricao}'),
            ],
          ),
          Row(
            children: [
              Campo(descricao:'Cadastro: '),
              Valor(valor: '${widget.pontoTuristico.cadastroFormatado}'),
            ],
          ),
          Row(
            children: [
              Campo(descricao:'Longitude: '),
              Valor(valor:'${widget.pontoTuristico.longitude}'),
            ],
          ),
          Row(
            children: [
              Campo(descricao:'Latitude: '),
              Valor(valor:'${widget.pontoTuristico.latitude}'),
            ],
          ),
          Row(
            children: [
              Campo(descricao:'Distância: '),
              Valor(valor:'${_calcularDistancia(widget.pontoTuristico.longitude, widget.pontoTuristico.latitude).toStringAsFixed(2)} Km'),
            ],
          ),
        ],
      ),
    );
  }

  double _calcularDistancia(double? longitude, double? latitude) {
    if (_localizacaoAtual == null) {
      return 0;
    }

    if(longitude == 0.0 || latitude == 0.0) {
      return 0;
    }

    double distanceInMeters = Geolocator.distanceBetween(
      _localizacaoAtual!.latitude,
      _localizacaoAtual!.longitude,
      latitude!,
      longitude!,
    );

    // Divide para deixar a distância em quilômetros.
    return distanceInMeters / 1000;
  }

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

class Campo extends StatelessWidget{
  final String descricao;

  const Campo({Key? key,required this.descricao}) : super(key: key);

  @override
  Widget build (BuildContext context){
    return Expanded(
      flex: 1,
      child: Text(descricao,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class Valor extends StatelessWidget{
  final String valor;

  const Valor({Key? key,required this.valor}) : super(key: key);

  @override
  Widget build (BuildContext context){
    return Expanded(
      flex: 4,
      child: Text(valor),
    );
  }
}