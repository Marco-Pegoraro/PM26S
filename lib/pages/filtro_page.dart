import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_turismo/model/ponto_turistico.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FiltroPage extends StatefulWidget {

  static const ROUTE_NAME = '/filtro';
  static const CHAVE_CAMPO_ORDENACAO = 'campoOrdenacao';
  static const CHAVE_USAR_ORDEM_DECRESCENTE = 'usarOdemDecrescente';
  static const CHAVE_FILTRO_DESCRICAO = 'filtroDescricao';

  @override
  _FiltroPageState createState() => _FiltroPageState();

}

class _FiltroPageState extends State<FiltroPage> {

  final _camposParaOrdenacao = {
    PontoTuristico.CAMPO_ID : 'Código',
    PontoTuristico.CAMPO_NOME : 'Nome',
    PontoTuristico.CAMPO_DESCRICAO : 'Descrição',
    PontoTuristico.CAMPO_CADASTRO : 'Data Cadastro'
  };

  late final SharedPreferences pref;
  final descricaoController = TextEditingController();
  String campoOrdenacao = PontoTuristico.CAMPO_ID;
  bool usarOrdemDecrescente = false;
  bool _alterouValores = false;

  @override
  void initState() {
    super.initState();
    _carregaSharedPreferences();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(title: Text('Filtro e Ordenação')),
          body: _criarBody(),
        ),
        onWillPop: _onClickVoltar
    );
  }

  void _carregaSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    pref = prefs;
    setState(() {
      campoOrdenacao = pref.getString(FiltroPage.CHAVE_CAMPO_ORDENACAO) ?? PontoTuristico.CAMPO_ID;
      usarOrdemDecrescente = pref.getBool(FiltroPage.CHAVE_USAR_ORDEM_DECRESCENTE) ?? false;
      descricaoController.text = pref.getString(FiltroPage.CHAVE_FILTRO_DESCRICAO) ?? '';
    });
  }

  Widget _criarBody() {
    return ListView(
      children: [
        Padding(padding: EdgeInsets.only(left: 10, top: 10), child: Text('Campo para ordenação')),
        for (final campo in _camposParaOrdenacao.keys)
          Row(
            children: [
              Radio(
                  value: campo,
                  groupValue: campoOrdenacao,
                  onChanged: _onCampoOrdenacaoChange
              ),
              Text(_camposParaOrdenacao[campo] ?? '')
            ],
          ),
        Divider(),
        Row(
          children: [
            Checkbox(value: usarOrdemDecrescente, onChanged: _onUserDecrescenteChange),
            Text('Usar ordem decrescente')
          ],
        ),
        Divider(),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              decoration: InputDecoration(labelText: 'Descrição começa com'),
              controller: descricaoController,
              onChanged: _onFiltroDescricaoChange,
            )
        )
      ],
    );
  }

  Future<bool> _onClickVoltar() async {
    Navigator.of(context).pop(_alterouValores);
    return true;
  }

  void _onFiltroDescricaoChange(String? valor) {
    pref.setString(FiltroPage.CHAVE_FILTRO_DESCRICAO, valor ?? '');
    _alterouValores == true;
  }

  void _onUserDecrescenteChange(bool? valor) {
    pref.setBool(FiltroPage.CHAVE_USAR_ORDEM_DECRESCENTE, valor == true);
    _alterouValores == true;
    setState(() {
      usarOrdemDecrescente = valor == true;
    });
  }

  void _onCampoOrdenacaoChange(String? valor) {
    pref.setString(FiltroPage.CHAVE_CAMPO_ORDENACAO, valor ?? '');
    _alterouValores == true;
    setState(() {
      usarOrdemDecrescente = valor == true;
    });
  }

}