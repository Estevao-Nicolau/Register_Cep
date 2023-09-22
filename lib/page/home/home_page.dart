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
  final TextEditingController searchController = TextEditingController();
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
  List<ClienteModel> searchResults = [];
  void searchClientes(String query) {
    setState(() {
      searchResults = clientes.where((cliente) {
        return cliente.nome.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void openEditDialog(ClienteModel cliente) {
    showDialog(
      context: context,
      builder: (context) {
        return EditClientDialog(cliente: cliente);
      },
    );
  }

  void toggleCard() {
    setState(() {
      isCardOpen = !isCardOpen;
    });
  }

  void fillFormFieldsWithCliente(int index) {
    nomeController.text = clientes[index].nome;
    ruaController.text = clientes[index].rua;
    bairroController.text = clientes[index].bairro;
    numeroController.text = clientes[index].numero;
    cidadeController.text = clientes[index].cidade;
    cepController.text = clientes[index].cep;
  }

  void editCliente(int index) async {
    fillFormFieldsWithCliente(index);
    final result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Cliente'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nomeController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                TextFormField(
                  controller: ruaController,
                  decoration: const InputDecoration(labelText: 'Rua'),
                ),
                TextFormField(
                  controller: bairroController,
                  decoration: const InputDecoration(labelText: 'Bairro'),
                ),
                TextFormField(
                  controller: numeroController,
                  decoration: const InputDecoration(labelText: 'Número'),
                ),
                TextFormField(
                  controller: cidadeController,
                  decoration: const InputDecoration(labelText: 'Cidade'),
                ),
                TextFormField(
                  controller: cepController,
                  decoration: const InputDecoration(labelText: 'CEP'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  clientes[index] = ClienteModel(
                    nome: nomeController.text,
                    rua: ruaController.text,
                    bairro: bairroController.text,
                    numero: numeroController.text,
                    cidade: cidadeController.text,
                    cep: cepController.text,
                  );
                });
                Navigator.of(context).pop(true);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    if (result == true) {}
  }

  void removeCliente(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir Cliente'),
          content:
              const Text('Tem certeza de que deseja excluir este cliente?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  clientes.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
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
                controller: searchController,
                onChanged: (query) {
                  searchClientes(query);
                },
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
          // Lista de sugestões
          ListView.builder(
            shrinkWrap: true,
            itemCount: searchResults.length > 4 ? 4 : searchResults.length,
            itemBuilder: (context, index) {
              final cliente = searchResults[index];
              return ListTile(
                title: Text(cliente.nome),
                // Outros detalhes do cliente aqui
                onTap: () {
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                        searchResults.length > 4 ? 4 : searchResults.length,
                    itemBuilder: (context, index) {
                      final cliente = searchResults[index];
                      return ListTile(
                        title: Text(cliente.nome),
                        onTap: () {
                          openEditDialog(cliente);
                        },
                      );
                    },
                  );
                  fillFormFieldsWithCliente(clientes.indexOf(cliente));
                },
              );
            },
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
                  builder: (context) => ListClients(
                    clients: clientes,
                    onRemove: removeCliente,
                    onEdit: editCliente,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class EditClientDialog extends StatelessWidget {
  final ClienteModel cliente;

  const EditClientDialog({super.key, required this.cliente});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Cliente'),
      content: CardRegister(
        nomeController: TextEditingController(text: cliente.nome),
        ruaController: TextEditingController(text: cliente.rua),
        bairroController: TextEditingController(text: cliente.bairro),
        numeroController: TextEditingController(text: cliente.numero),
        cidadeController: TextEditingController(text: cliente.cidade),
        cepController: TextEditingController(text: cliente.cep),
        onSavePressed: () {
          // Implemente a lógica para salvar as alterações aqui
          // Você pode atualizar o objeto cliente com os valores dos controladores
          Navigator.of(context).pop(); // Feche o diálogo após salvar
        },
        isCardOpen: true, // Abra o card no diálogo
      ),
    );
  }
}