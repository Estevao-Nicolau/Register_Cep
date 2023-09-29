import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:register_cep/back4app/back4app_api.dart';
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

  final Back4appAPI back4appAPI = Back4appAPI();
  List<ClienteModel>? searchResults;
  List<ClienteModel>? clients;
  final api = Back4appAPI();

  @override
  void initState() {
    super.initState();
    _loadDataFromApi();
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
    nomeController.text = clientes[index].nome!;
    ruaController.text = clientes[index].rua!;
    bairroController.text = clientes[index].bairro!;
    numeroController.text = clientes[index].numero!;
    cidadeController.text = clientes[index].cidade!;
    cepController.text = clientes[index].cep!;
  }

  void searchClientes(List<ClienteModel> clientes, String query) {
    setState(() {
      if (query.isEmpty) {
        // Se a consulta estiver vazia, exibir todos os clientes.
        searchResults = clientes;
      } else {
        // Caso contrário, filtrar os clientes pelo nome.
        searchResults = clientes
            .where((cliente) =>
                cliente.nome?.toLowerCase().contains(query.toLowerCase()) ??
                false)
            .toList();
      }
    });
  }

  Future<void> _loadDataFromApi() async {
    try {
      final apiResults = await api.fetchData();

      if (apiResults != null) {
        setState(() {
          clients = apiResults.map((result) {
            return ClienteModel(
              objectId: result.objectId,
              nome: result.name,
              rua: result.address?.road,
              bairro: result.address?.bairro,
              numero: result.address?.number,
              cidade: result.address?.city,
              cep: result.address?.cep,
            );
          }).toList();
          searchResults = clients;
          
        });
      } else {
        // Lidar com o caso em que apiResults é nulo ou vazio, se necessário.
      }
    } catch (e) {
      // Lidar com erros, por exemplo, exibir uma mensagem de erro.
    }
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
                    objectId: clientes[index].objectId,
                    nome: nomeController.text,
                    rua: ruaController.text,
                    bairro: bairroController.text,
                    numero: numeroController.text,
                    cidade: cidadeController.text,
                    cep: cepController.text,
                  );
                  print(clientes[index].objectId);
                },
               
                );
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
        title: const Text('Bem vindo'),
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
                  if (clients != null) {
                    searchClientes(clients!, query);
                  }
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
            itemCount: searchController.text.isEmpty
                ? 0
                : (searchResults!.length > 4 ? 4 : searchResults!.length),
            itemBuilder: (context, index) {
              final cliente = searchResults![index];
              return ListTile(
                title: Text(cliente.nome!),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return ViewClientDetailsDialog(cliente: cliente);
                    },
                  );
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
                setState(() async {
                  isCardOpen = false;
                  ClienteModel novoCliente = ClienteModel(
                    objectId: null,
                    nome: nomeController.text,
                    rua: ruaController.text,
                    bairro: bairroController.text,
                    numero: numeroController.text,
                    cidade: cidadeController.text,
                    cep: cepController.text,
                  );
                  // Chamar o método postData da classe Back4appAPI para salvar o cliente
                  await back4appAPI.postData(novoCliente);
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
                    objectId: null,
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
          Navigator.of(context).pop();
        },
        isCardOpen: true, // Abra o card no diálogo
      ),
    );
  }
}

class ViewClientDetailsDialog extends StatelessWidget {
  final ClienteModel cliente;

  const ViewClientDetailsDialog({super.key, required this.cliente});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Detalhes do Cliente'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${cliente.nome}'),
            Text('Rua: ${cliente.rua}'),
            Text('Bairro: ${cliente.bairro}'),
            Text('Número: ${cliente.numero}'),
            Text('Cidade: ${cliente.cidade}'),
            Text('CEP: ${cliente.cep}'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
