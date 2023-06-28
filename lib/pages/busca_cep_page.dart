import 'package:flutter/material.dart';
import '../model/cep.dart';
import '../model/ponto_turistico.dart';
import '../services/cep_service.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class BuscaCepPage extends StatefulWidget {

  final PontoTuristico pontoTuristico;

  const BuscaCepPage({Key? key, required this.pontoTuristico}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BuscaCepPage();

}

class _BuscaCepPage extends State<BuscaCepPage> {

  final _service = CepService();

  final _controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var _loading = false;

  final _cepFormatter = MaskTextInputFormatter(
      mask: '#####-###',
      filter: {'#' : RegExp(r'[0-9]')}
  );

  Cep? _cep;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _criaAppBar(),
        body: _criarBody()
    );
  }

  AppBar _criaAppBar() {
    return AppBar(
        title: Text('Busca CEP')
    );
  }

  Widget _criarBody() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'CEP',
                suffixIcon: _loading ? const Padding(
                  padding: EdgeInsets.all(10),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ) : IconButton(
                  onPressed: _findCep,
                  icon: const Icon(Icons.search),
                ),
              ),
              inputFormatters: [_cepFormatter],
              validator: (String? value){
                if(value == null || value.isEmpty || !_cepFormatter.isFill()){
                  return 'Informe um cep válido';
                }
                return null;
              },
            ),
          ),
          Container(height: 10,),
          ..._buildResultWidgets(),
        ],
      ),
    );
  }

  Future<void> _findCep() async{
    if(_formKey.currentState == null || !_formKey.currentState!.validate()){
      return;
    }
    setState(() {
      _loading = true;
    });
    try{
      _cep = await _service.findCepAsobject(_cepFormatter.getUnmaskedText());
    } catch(e){
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Ocorreu um erro ao consultar o CEP. Tente novamente'),
      ));
    }
    setState(() {
      _loading = false;
    });
  }

  List<Widget> _buildResultWidgets(){
    final List<Widget> widgets = [];
    if(_cep != null){
      final map = _cep!.tojson();
      for(final key in map.keys){
        widgets.add(Text('$key: ${map[key]}'));
      }
    }
    return widgets;
  }

}
