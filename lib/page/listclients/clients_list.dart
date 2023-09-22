import 'package:flutter/material.dart';
import 'package:register_cep/model/clients_model.dart';
class ListClients extends StatelessWidget {
  final List<ClienteModel> clients;
  final Function(int) onRemove;
  final Function(int) onEdit;

  const ListClients({Key? key, required this.clients, required this.onRemove, required this.onEdit, })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Clientes'),
      ),
      body: ListView.builder(
        itemCount: clients.length,
        itemBuilder: (context, index) {
          final cliente = clients[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              title: Text(cliente.nome),
              initiallyExpanded: false,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                     onEdit(index);
                    },
                    color: Colors.orange, // Cor laranja para o botão de edição
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      onRemove(index); // Chame o método para remover o cliente
                    },
                    color: Colors.red, // Cor vermelha para o botão de exclusão
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