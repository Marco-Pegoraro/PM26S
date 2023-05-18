import 'dart:ffi';

import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class PontoTuristico {

  static const NOME_TABELA = 'pontos';
  static const CAMPO_ID = 'id';
  static const CAMPO_NOME = 'nome';
  static const CAMPO_DESCRICAO = 'descricao';
  static const CAMPO_CADASTRO = 'cadastro';
  static const CAMPO_LONGITUDE = 'longitude';
  static const CAMPO_LATITUDE = 'latitude';

  int? id;
  String nome;
  String descricao;
  DateTime? cadastro;
  double? longitude;
  double? latitude;

  PontoTuristico({
    this.id,
    required this.nome,
    required this.descricao,
    this.cadastro,
    this.longitude,
    this.latitude
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
    CAMPO_LONGITUDE: longitude,
    CAMPO_LATITUDE: latitude
  };

  factory PontoTuristico.fromMap(Map<String, dynamic> map) => PontoTuristico(
    id: map[CAMPO_ID] is int ? map[CAMPO_ID] : null,
    nome: map[CAMPO_NOME] is String ? map[CAMPO_NOME] : '',
    descricao: map[CAMPO_DESCRICAO] is String ? map[CAMPO_DESCRICAO] : '',
    cadastro: map[CAMPO_CADASTRO] is String
        ? DateFormat("yyyy-MM-dd").parse(map[CAMPO_CADASTRO])
        : null,
    longitude: map[CAMPO_LONGITUDE] is double ? map[CAMPO_LONGITUDE] : 0,
    latitude: map[CAMPO_LATITUDE] is double ? map[CAMPO_LATITUDE] : 0
  );

}