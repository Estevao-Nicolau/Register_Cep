import 'package:flutter/material.dart';
import 'package:register_cep/model/clients_model.dart';

class ListClients extends StatelessWidget {
  final List<ClienteModel> clients;

  const ListClients({super.key, required this.clients});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: clients.length,
      itemBuilder: (context, index) {
        final cliente = clients[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(cliente.nome),
            subtitle: Text('${cliente.rua}, ${cliente.bairro}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // Implemente a lógica para excluir o cliente da lista aqui.
              },
            ),
          ),
        );
      },
    );
  }
}
