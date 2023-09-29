import 'package:flutter/material.dart';
import 'package:register_cep/back4app/back4app_api.dart';
import 'package:register_cep/model/clients_model.dart';
import 'package:register_cep/page/home/widget/card_%20register.dart';

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
  List<ClienteModel>? clients;
  final api = Back4appAPI();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDataFromApi();
  }

  void _handleEdit(int index, ClienteModel updatedClient) {
    updateClientList(index, updatedClient);
    Navigator.of(context).pop(); // Feche o diálogo de edição
  }

  void updateClientList(int index, ClienteModel updatedClient) {
    setState(() {
      clients![index] = updatedClient;
    });
  }

  Future<void> _loadDataFromApi() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

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
        });
      } else {
        // Handle the case where apiResults is null or empty if necessary.
      }
    } catch (e) {
      // Handle errors, for example, display an error message.
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Clientes'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(), // Show loading indicator
            )
          : clients == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
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
                                // Open the EditClientDialog when the "EDIT" button is clicked
                                showDialog(
                                  context: context,
                                  builder: (context) => EditClientDialog(
                                    cliente: clients![index],
                                    onEdit: (updatedClient) {
                                      // Update the client in the list
                                      updateClientList(index, updatedClient);
                                    },
                                  ),
                                );
                              },
                              color: Colors.orange,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                try {
                                  final cliente = clients![index];
                                  final objectId = cliente.objectId;

                                  await api.deleteData(objectId!);
                                  // Após excluir com sucesso, você pode atualizar a lista para refletir a alteração
                                  setState(() {
                                    clients!.removeAt(index);
                                  });
                                  // Exiba uma mensagem de sucesso ou qualquer feedback necessário
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Cliente excluído com sucesso.'),
                                    ),
                                  );
                                } catch (e) {
                                  // Lidar com erros, por exemplo, exibir uma mensagem de erro.
                                  print('Erro ao excluir o cliente: $e');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Erro ao excluir o cliente.'),
                                    ),
                                  );
                                }
                              },
                              color: Colors.red,
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

class EditClientDialog extends StatefulWidget {
  final ClienteModel cliente;
  final Function(ClienteModel) onEdit; // Adicione este parâmetro

  const EditClientDialog({Key? key, required this.cliente, required this.onEdit}) : super(key: key);

  @override
  _EditClientDialogState createState() => _EditClientDialogState();
}

class _EditClientDialogState extends State<EditClientDialog> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController ruaController = TextEditingController();
  TextEditingController bairroController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();
  TextEditingController cepController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the client's data
    nomeController.text = widget.cliente.nome ?? '';
    ruaController.text = widget.cliente.rua ?? '';
    bairroController.text = widget.cliente.bairro ?? '';
    numeroController.text = widget.cliente.numero ?? '';
    cidadeController.text = widget.cliente.cidade ?? '';
    cepController.text = widget.cliente.cep ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Cliente'),
      content: CardRegister(
        nomeController: nomeController,
        ruaController: ruaController,
        bairroController: bairroController,
        numeroController: numeroController,
        cidadeController: cidadeController,
        cepController: cepController,
        onSavePressed: () async {
          // Create a new ClienteModel with updated data
          ClienteModel updatedClient = ClienteModel(
            objectId: widget.cliente.objectId,
            nome: nomeController.text,
            rua: ruaController.text,
            bairro: bairroController.text,
            numero: numeroController.text,
            cidade: cidadeController.text,
            cep: cepController.text,
          );

          // Call the _handleEdit method in the parent widget to update the client data
          widget.onEdit(updatedClient);

          // Close the dialog
          Navigator.of(context).pop();
        },

        isCardOpen: true, // Open the card in the dialog
      ),
    );
  }
}
