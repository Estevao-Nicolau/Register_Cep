import 'package:flutter/material.dart';
import 'package:register_cep/model/cep_model.dart';
import 'package:register_cep/model/clients_model.dart';
import 'package:register_cep/page/home/widget/card_%20register.dart';
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
  List<ClienteModel> clientes = [];
  CepService cepService = CepService();

  void toggleCard() {
    setState(() {
      isCardOpen = !isCardOpen;
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
                });

                // Obtenha o CEP do campo cepController
                String cep = cepController.text;

                // Use o cepService para buscar informações do CEP
                CepModel? cepData = await cepService.fetchCep(cep);

                if (cepData != null) {
                  // Preencha os campos de rua, bairro e cidade com os dados do CEP
                  ruaController.text = cepData.logradouro ?? '';
                  bairroController.text = cepData.bairro ?? '';
                  cidadeController.text = cepData.localidade ?? '';
                } else {
                  // Lidar com erros, como CEP não encontrado
                  print('CEP não encontrado ou ocorreu um erro.');
                }

                // Adicione o cliente à lista
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

                print(clientes[0].toJson());
              },
              isCardOpen: isCardOpen,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleCard,
        child: const Icon(Icons.add),
      ),
    );
  }
}
