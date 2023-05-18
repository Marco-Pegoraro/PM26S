import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:projeto_turismo/dao/ponto_dao.dart';
import 'package:projeto_turismo/model/ponto_turistico.dart';
import 'package:projeto_turismo/pages/detalhes_ponto_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/conteudo_form_dialog.dart';
import 'filtro_page.dart';
import 'mapa_page.dart';

class ListaPontosPage extends StatefulWidget {

  @override
  _ListaPontosPageState createState() => _ListaPontosPageState();

}

class _ListaPontosPageState extends State<ListaPontosPage> {

  static const ACAO_EDITAR = 'editar';
  static const ACAO_EXCLUIR = 'excluir';
  static const ACAO_VISUALIZAR = 'visualizar';
  static const ACAO_MAPA_EXTERNO = 'externo';
  static const ACAO_MAPA_INTERNO = 'interno';

  final _pontos = <PontoTuristico> [];
  final _dao = PontoDao();
  var _carregando = false;
  final _controller = TextEditingController();

  @override
  void initState(){
    super.initState();
    _atualizarLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _criaAppBar(),
      body: _criarBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirForm,
        tooltip: 'Novo Ponto Turistico',
        child: Icon(Icons.add),
      ),
    );
  }

  AppBar _criaAppBar() {
    return AppBar(
      title: Text('Gerenciador de Pontos Turísticos'),
      actions: [
        IconButton(
          onPressed: _abrirPaginaFiltro,
          icon: Icon(Icons.filter_list),
        )
      ],
    );
  }

  Widget _criarBody() {
    if(_carregando){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.center,
            child: CircularProgressIndicator(),
          ),
          Align(
            alignment: AlignmentDirectional.center,
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text('Carregando seus Pontos Turísticos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          )
        ],
      );
    }
    if(_pontos.isEmpty) {
      return const Center(
        child: Text(
            'Nenhum ponto turístico cadastrado',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
        ),
      );
    }
    return ListView.separated(
        itemBuilder : (BuildContext context, int index) {
          final ponto = _pontos[index];
          return PopupMenuButton<String>(
            child: ListTile(
              title: Text('${ponto.id} - ${ponto.nome}'),
              subtitle: Text(ponto.descricao == null ? '${ponto.cadastroFormatado} | Ponto sem descrição' : '${ponto.cadastroFormatado} | ${ponto.descricao}'),
            ),
            itemBuilder: (BuildContext context) => criarItensMenuPopup(),
            onSelected: (String valorSelecionado) {
              if(valorSelecionado == ACAO_EDITAR) {
                _abrirForm(pontoAtual: ponto);
              } else if (valorSelecionado == ACAO_VISUALIZAR) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => DetalhesPontoPage(pontoTuristico: ponto),
                ));
              } else if (valorSelecionado == ACAO_MAPA_EXTERNO) {
                _controller.text = "${ponto.latitude}, ${ponto.longitude}";
                _abrirTextoMapaExterno();
              } else if (valorSelecionado == ACAO_MAPA_INTERNO) {
                _abrirMapaInterno(ponto.longitude, ponto.latitude);
              } else {
                _excluir(ponto);
              }
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: _pontos.length
    );
  }

  void _abrirPaginaFiltro() {
    final navigator = Navigator.of(context);
    navigator.pushNamed(FiltroPage.ROUTE_NAME).then((alterouValores) {
      if(alterouValores == true) {

      }
    });
  }

  List<PopupMenuEntry<String>> criarItensMenuPopup() {
    return[
      PopupMenuItem<String>(
          value: ACAO_EDITAR,
          child: Row(
              children: [
                Icon(Icons.edit, color: Colors.black),
                Padding(padding: EdgeInsets.only(left: 10), child: Text('Editar'))
              ]
          )
      ),
      PopupMenuItem<String>(
          value: ACAO_EXCLUIR,
          child: Row(
              children: [
                Icon(Icons.delete, color: Colors.red),
                Padding(padding: EdgeInsets.only(left: 10), child: Text('Excluir'))
              ]
          )
      ),
      PopupMenuItem<String>(
          value: ACAO_VISUALIZAR,
          child: Row(
            children: [
              Icon(Icons.info, color: Colors.blue),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Visualizar'),
              )
            ],
          )
      ),
      PopupMenuItem<String>(
          value: ACAO_MAPA_EXTERNO,
          child: Row(
            children: [
              Icon(Icons.map, color: Colors.green),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Mapa Externo'),
              )
            ],
          )
      ),
      PopupMenuItem<String>(
          value: ACAO_MAPA_INTERNO,
          child: Row(
            children: [
              Icon(Icons.map, color: Colors.lightGreen),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Mapa Interno'),
              )
            ],
          )
      )
    ];
  }

  void _atualizarLista() async {
    setState(() {
      _carregando = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final campoOrdenacao =
        prefs.getString(FiltroPage.CHAVE_CAMPO_ORDENACAO) ?? PontoTuristico.CAMPO_ID;
    final usarOrdemDecrescente =
        prefs.getBool(FiltroPage.CHAVE_USAR_ORDEM_DECRESCENTE) == true;
    final filtroDescricao =
        prefs.getString(FiltroPage.CHAVE_FILTRO_DESCRICAO) ?? '';
    final pontos = await _dao.listar(
      filtro: filtroDescricao,
      campoOrdenacao: campoOrdenacao,
      usarOrdemDecrescente: usarOrdemDecrescente,
    );
    setState(() {
      _pontos.clear();
      if (pontos.isNotEmpty) {
        _pontos.addAll(pontos);
      }
    });
    setState(() {
      _carregando = false;
    });
  }

  void _abrirForm({PontoTuristico? pontoAtual}) {
    final key = GlobalKey<ConteudoFormDialogState>();
    showDialog(
        context: context,
        builder: (_) => AlertDialog (
            title: Text(pontoAtual == null ? 'Novo ponto turístico' : 'Alterar ponto turístico ${pontoAtual.id}'),
            content: ConteudoFormDialog(key: key, pontoAtual: pontoAtual),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancelar')),
              TextButton(onPressed: () {
                if (key.currentState?.dadosValidados() != true) {
                  return;
                }
                Navigator.of(context).pop();
                final novoPonto = key.currentState!.novoPonto;
                _dao.salvar(novoPonto).then((success) {
                  if (success) {
                    _atualizarLista();
                  }
                });
                _atualizarLista();
              }, child: Text('Salvar'))
            ],
        )
    );
  }

  void _excluir(PontoTuristico pontoTuristico) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.warning, color: Colors.red),
                Padding(padding: EdgeInsets.only(left: 10), child: Text('ATENÇÃO'))
              ],
            ),
            content: Text('Esse registro sera deletado de forma permanente'),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancelar')),
              TextButton(onPressed: () {
                Navigator.of(context).pop();
                if(pontoTuristico.id == null){
                  return;
                }
                _dao.remover(pontoTuristico.id!).then((sucess) {
                  if (sucess)
                    _atualizarLista();
                });
              } , child: Text('OK'))
            ],
          );
        }
    );
  }

  void _abrirMapaInterno(double? longitude, double? latitude) {
    if(longitude == 0 || latitude == 0 || longitude == null || latitude == null){
      return;
    }
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) => MapasPage(
        latitude: latitude!,
        longetude: longitude!,
      ),
    ),
    );
  }

  void _abrirTextoMapaExterno() {
    if(_controller.text.trim().isEmpty){
      return;
    }
    MapsLauncher.launchQuery(_controller.text);
  }

}