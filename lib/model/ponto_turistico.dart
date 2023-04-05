import 'package:intl/intl.dart';

class PontoTuristico {

  static const NOME_TABELA = 'pontos';
  static const CAMPO_ID = 'id';
  static const CAMPO_NOME = 'nome';
  static const CAMPO_DESCRICAO = 'descricao';
  static const CAMPO_CADASTRO = 'cadastro';

  int? id;
  String nome;
  String descricao;
  DateTime? cadastro;

  PontoTuristico({
    this.id,
    required this.nome,
    required this.descricao,
    this.cadastro
  });

  String get cadastroFormatado {
    if(cadastro == null) {
      return '';
    }
    return DateFormat('dd/MM/yyyy').format(cadastro!);
  }

  Map<String, dynamic> toMap() => {
    CAMPO_ID: id,
    CAMPO_NOME: nome,
    CAMPO_DESCRICAO: descricao,
    CAMPO_CADASTRO:
    cadastro == null ? null : DateFormat("yyyy-MM-dd").format(cadastro!),
  };

  factory PontoTuristico.fromMap(Map<String, dynamic> map) => PontoTuristico(
    id: map[CAMPO_ID] is int ? map[CAMPO_ID] : null,
    nome: map[CAMPO_NOME] is String ? map[CAMPO_NOME] : '',
    descricao: map[CAMPO_DESCRICAO] is String ? map[CAMPO_DESCRICAO] : '',
    cadastro: map[CAMPO_CADASTRO] is String
        ? DateFormat("yyyy-MM-dd").parse(map[CAMPO_CADASTRO])
        : null,
  );

}