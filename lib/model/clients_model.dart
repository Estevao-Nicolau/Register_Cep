class ClienteModel {
  String nome;
  String rua;
  String bairro;
  String numero;
  String cidade;
  String cep;

  ClienteModel({
    required this.nome,
    required this.rua,
    required this.bairro,
    required this.numero,
    required this.cidade,
    required this.cep,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'rua': rua,
      'bairro': bairro,
      'numero': numero,
      'cidade': cidade,
      'cep': cep,
    };
  }
}
