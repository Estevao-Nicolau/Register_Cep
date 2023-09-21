import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:register_cep/model/cep_model.dart';
import 'package:register_cep/model/clients_model.dart';
import 'package:register_cep/page/home/widget/card_%20register.dart';
import 'package:register_cep/page/listclients/clients_list.dart';
import 'package:register_cep/services/cep_services.dart'; // Substitua pelo caminho correto do seu serviço CepService

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController ruaController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  bool isCardOpen = false;
  List<ClienteModel> cliente = [];
  CepService cepService = CepService();
  List<ClienteModel> clientes = [];

  void toggleCard() {
    setState(() {
      isCardOpen = !isCardOpen;
    });
  }
  
  void removeCliente(int index) {
  setState(() {
    clientes.removeAt(index);
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Pesquisa',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
          Expanded(
            child: CardRegister(
              nomeController: nomeController,
              ruaController: ruaController,
              bairroController: bairroController,
              numeroController: numeroController,
              cidadeController: cidadeController,
              cepController: cepController,
              onSavePressed: () async {
                setState(() {
                  isCardOpen = false;
                  clientes.add(
                    ClienteModel(
                      nome: nomeController.text,
                      rua: ruaController.text,
                      bairro: bairroController.text,
                      numero: numeroController.text,
                      cidade: cidadeController.text,
                      cep: cepController.text,
                    ),
                  );
                  nomeController.clear();
                  ruaController.clear();
                  bairroController.clear();
                  numeroController.clear();
                  cidadeController.clear();
                  cepController.clear();
                });

                String cep = cepController.text;
                CepModel? cepData = await cepService.fetchCep(cep);
                if (cepData != null) {
                  ruaController.text = cepData.logradouro ?? '';
                  bairroController.text = cepData.bairro ?? '';
                  cidadeController.text = cepData.localidade ?? '';
                } else {
                  // Lidar com erros, como CEP não encontrado
                  print('CEP não encontrado ou ocorreu um erro.');
                }
                cliente.add(
                  ClienteModel(
                    nome: nomeController.text,
                    rua: ruaController.text,
                    bairro: bairroController.text,
                    numero: numeroController.text,
                    cidade: cidadeController.text,
                    cep: cepController.text,
                  ),
                );

                print(cliente[0].toJson());
              },
              isCardOpen: isCardOpen,
            ),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.add),
            label: 'Adicionar',
            onTap: toggleCard,
          ),
          SpeedDialChild(
            child: const Icon(Icons.list),
            label: 'Lista de Clientes',
            onTap: () {
              Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ListClients(clients: clientes, onRemove: removeCliente, onEdit: null,),
      ),);
            },
          ),
        ],
      ),
    );
  }
}
