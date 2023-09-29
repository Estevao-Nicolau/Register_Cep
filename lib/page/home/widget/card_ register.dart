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
  final bool isCardOpen;

  const CardRegister({
    Key? key,
    required this.cepController,
    required this.nomeController,
    required this.ruaController,
    required this.bairroController,
    required this.numeroController,
    required this.cidadeController,
    required this.onSavePressed,
    required this.isCardOpen,
  }) : super(key: key);

  @override
  State<CardRegister> createState() => _CardRegisterState();
}

class _CardRegisterState extends State<CardRegister> {
  CepService cepService = CepService();

  @override
  Widget build(BuildContext context) {
    return widget.isCardOpen
        ? SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: [
                  TextFormField(
                    controller: widget.cepController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'CEP'),
                    onEditingComplete: () async {
                      String cep = widget.cepController.text;
                      CepModel? cepData = await cepService.fetchCep(cep);

                      if (cepData != null) {
                        setState(() {
                          widget.ruaController.text = cepData.logradouro ?? '';
                          widget.bairroController.text = cepData.bairro ?? '';
                          widget.cidadeController.text =
                              cepData.localidade ?? '';
                        });
                      } else {
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
            ),
          )
        : Container();
  }
}
