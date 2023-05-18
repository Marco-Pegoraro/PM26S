import 'package:projeto_turismo/model/ponto_turistico.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static const _dbName = 'cadastro_pontos_teste.db';
  static const _dbVersion = 1;

  DatabaseProvider._init();
  static final DatabaseProvider instance = DatabaseProvider._init();

  Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final dbPath = '$databasesPath/$_dbName';
    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE ${PontoTuristico.NOME_TABELA} (
        ${PontoTuristico.CAMPO_ID} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${PontoTuristico.CAMPO_NOME} TEXT NOT NULL,
        ${PontoTuristico.CAMPO_DESCRICAO} TEXT NOT NULL,
        ${PontoTuristico.CAMPO_CADASTRO} TEXT, 
        ${PontoTuristico.CAMPO_LONGITUDE} REAL, 
        ${PontoTuristico.CAMPO_LATITUDE} REAL);
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    switch(oldVersion){
      case 2:
        await db.execute('''
        ALTER TABLE ${PontoTuristico.NOME_TABELA}
        ADD ${PontoTuristico.CAMPO_LONGITUDE} REAL;
        ''');

        await db.execute('''
        ALTER TABLE ${PontoTuristico.NOME_TABELA}
        ADD ${PontoTuristico.CAMPO_LATITUDE} REAL;
        ''');
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
  }

}