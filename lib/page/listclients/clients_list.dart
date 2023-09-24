import 'package:flutter/material.dart';
import 'package:register_cep/back4app/back4app_api.dart';
import 'package:register_cep/model/clients_model.dart';

class ListClients extends StatefulWidget {
  final List<ClienteModel> clients;
  final Function(int) onRemove;
  final Function(int) onEdit;

  const ListClients({
    Key? key,
    required this.clients,
    required this.onRemove,
    required this.onEdit,
  }) : super(key: key);

  @override
  State<ListClients> createState() => _ListClientsState();
}

class _ListClientsState extends State<ListClients> {
  List<ClienteModel>? clients; // Alterado para ser uma lista nula inicialmente
  final api = Back4appAPI();

  @override
  void initState() {
    super.initState();
    _loadDataFromApi();
  }

  Future<void> _loadDataFromApi() async {
    try {
      final apiResults = await api.fetchData();

      if (apiResults != null) {
        setState(() {
          clients = apiResults.map((result) {
            return ClienteModel(
              nome: result.name,
              rua: result.address?.road,
              bairro: result.address?.bairro,
              numero: result.address?.number,
              cidade: result.address?.city,
              cep: result.address?.cep,
            );
          }).toList();
        });
      } else {
        // Lidar com o caso em que apiResults é nulo ou vazio, se necessário.
      }
    } catch (e) {
      // Lidar com erros, por exemplo, exibir uma mensagem de erro.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Clientes'),
      ),
      body: clients == null
          ? const Center(
              child:
                  CircularProgressIndicator()) // Mostra um indicador de carregamento enquanto os dados estão sendo buscados
          : ListView.builder(
              itemCount: clients!.length,
              itemBuilder: (context, index) {
                final cliente = clients![index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    title: Text(cliente.nome!),
                    initiallyExpanded: false,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            widget.onEdit(index);
                          },
                          color: Colors
                              .orange, // Cor laranja para o botão de edição
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            widget.onRemove(
                                index); // Chame o método para remover o cliente
                          },
                          color: Colors
                              .red, // Cor vermelha para o botão de exclusão
                        ),
                      ],
                    ), // Defina como false para expandir somente quando clicado
                    children: [
                      ListTile(
                        title: Text('Rua: ${cliente.rua}'),
                      ),
                      ListTile(
                        title: Text('Bairro: ${cliente.bairro}'),
                      ),
                      ListTile(
                        title: Text('Número: ${cliente.numero}'),
                      ),
                      ListTile(
                        title: Text('Cidade: ${cliente.cidade}'),
                      ),
                      ListTile(
                        title: Text('CEP: ${cliente.cep}'),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
