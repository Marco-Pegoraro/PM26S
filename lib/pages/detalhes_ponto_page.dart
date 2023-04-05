import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_turismo/model/ponto_turistico.dart';

class DetalhesPontoPage extends StatefulWidget {

  final PontoTuristico pontoTuristico;

  const DetalhesPontoPage({Key? key, required this.pontoTuristico}) : super(key: key);

  @override
  _DetalhesPontoPageState createState() => _DetalhesPontoPageState();
}

class _DetalhesPontoPageState extends State<DetalhesPontoPage> {
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