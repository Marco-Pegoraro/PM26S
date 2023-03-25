import 'package:intl/intl.dart';

class PontoTuristico {

  static const CAMPO_ID = 'id';
  static const CAMPO_NOME = 'nome';
  static const CAMPO_DESCRICAO = 'descricao';
  static const CAMPO_CADASTRO = 'cadastro';

  int id;
  String nome;
  String descricao;
  DateTime? cadastro;

  PontoTuristico({required this.id, required this.nome, required this.descricao, this.cadastro});

  String get cadastroFormatado {
    if(cadastro == null) {
      return '';
    }
    return DateFormat('dd/MM/yyyy').format(cadastro!);
  }

}