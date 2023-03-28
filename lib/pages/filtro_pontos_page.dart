import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_turismo/model/ponto_turistico.dart';

import '../widgets/conteudo_form_dialog.dart';
import 'filtro_page.dart';

class ListaPontosPage extends StatefulWidget {

  @override
  _ListaPontosPageState createState() => _ListaPontosPageState();

}

class _ListaPontosPageState extends State<ListaPontosPage> {

  static const ACAO_EDITAR = 'editar';
  static const ACAO_EXCLUIR = 'excluir';

  final pontos = <PontoTuristico> [
    PontoTuristico(
        id: 1,
        nome: "Cristo Redentor",
        descricao: "Ponto Turistico brasileiro muito famoso",
        cadastro: DateTime.now()
    )
  ];
  int _ultimoId = 1;

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
    if(pontos.isEmpty) {
      return const Center(
        child: Text(
            'Nenhum ponto turístico cadastrado',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
        ),
      );
    }
    return ListView.separated(
        itemBuilder : (BuildContext context, int index) {
          final ponto = pontos[index];
          return PopupMenuButton<String>(
            child: ListTile(
              title: Text('${ponto.id} - ${ponto.nome}'),
              subtitle: Text(ponto.descricao == null ? '${ponto.cadastroFormatado} | Ponto sem descrição' : '${ponto.cadastroFormatado} | ${ponto.descricao}'),
            ),
            itemBuilder: (BuildContext context) => criarItensMenuPopup(),
            onSelected: (String valorSelecionado) {
              if(valorSelecionado == ACAO_EDITAR) {
                _abrirForm(pontoAtual: ponto, indice: index);
              } else {
                _excluir(index);
              }
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: pontos.length
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
      )
    ];
  }

  void _abrirForm({PontoTuristico? pontoAtual, int? indice}) {
    final key = GlobalKey<ConteudoFormDialogState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(pontoAtual == null ? 'Novo ponto turístico' : 'Alterar ponto turístico ${pontoAtual.id}'),
            content: ConteudoFormDialog(key: key, pontoAtual: pontoAtual),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancelar')),
              TextButton(onPressed: () {
                if(key.currentState != null && key.currentState!.dadosValidados()) {
                  setState(() {
                    final novoPonto = key.currentState!.novoPonto;
                    if(indice == null) {
                      novoPonto.id = ++ _ultimoId;
                      pontos.add(novoPonto);
                    } else {
                      pontos[indice] = novoPonto;
                    }
                  });
                  Navigator.of(context).pop();
                }
              }, child: Text('Salvar'))
            ],
          );
        }
    );
  }

  void _excluir(int index) {
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
                setState(() {
                  pontos.removeAt(index);
                });
              } , child: Text('OK'))
            ],
          );
        }
    );
  }

}