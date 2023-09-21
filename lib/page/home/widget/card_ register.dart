import 'package:flutter/material.dart';
import 'package:register_cep/model/cep_model.dart';
import 'package:register_cep/services/cep_services.dart';

class CardRegister extends StatefulWidget {
  final TextEditingController cepController;
  final TextEditingController nomeController;
  final TextEditingController ruaController;
  final TextEditingController bairroController;
  final TextEditingController numeroController;
  final TextEditingController cidadeController;
  final VoidCallback onSavePressed;
  final bool isCardOpen; // Adicione essa variável.

  const CardRegister({
    super.key,
    required this.cepController,
    required this.nomeController,
    required this.ruaController,
    required this.bairroController,
    required this.numeroController,
    required this.cidadeController,
    required this.onSavePressed,
    required this.isCardOpen,
  });

  @override
  State<CardRegister> createState() => _CardRegisterState();
}

class _CardRegisterState extends State<CardRegister> {
  CepService cepService = CepService();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.isCardOpen
            ? Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: widget.cepController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'CEP'),
                      onEditingComplete: () async {
                        // Obtenha o CEP do campo cepController
                        String cep = widget.cepController.text;

                        // Use o cepService para buscar informações do CEP
                        CepModel? cepData = await cepService.fetchCep(cep);

                        if (cepData != null) {
                          // Preencha os campos de rua, bairro e cidade com os dados do CEP
                          setState(() {
                            widget.ruaController.text =
                                cepData.logradouro ?? '';
                            widget.bairroController.text = cepData.bairro ?? '';
                            widget.cidadeController.text =
                                cepData.localidade ?? '';
                          });
                        } else {
                          // Lidar com erros, como CEP não encontrado
                          print('CEP não encontrado ou ocorreu um erro.');
                        }
                      },
                    ),
                    TextFormField(
                      controller: widget.nomeController,
                      decoration: const InputDecoration(labelText: 'Nome'),
                    ),
                    TextFormField(
                      controller: widget.ruaController,
                      decoration: const InputDecoration(labelText: 'Rua'),
                    ),
                    TextFormField(
                      controller: widget.bairroController,
                      decoration: const InputDecoration(labelText: 'Bairro'),
                    ),
                    TextFormField(
                      controller: widget.numeroController,
                      decoration: const InputDecoration(labelText: 'Número'),
                    ),
                    TextFormField(
                      controller: widget.cidadeController,
                      decoration: const InputDecoration(labelText: 'Cidade'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: widget.onSavePressed,
                      child: const Text('Salvar'),
                    ),
                  ],
                ),
              )
            : Container(), // Retorna um container vazio se o card estiver fechado.
      ],
    );
  }
}
