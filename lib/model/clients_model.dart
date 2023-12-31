class ClienteModel {
  String? objectId;
  String? nome;
  String? bairro;
  String? rua;
  String? numero;
  String? cidade;
  String? cep;

  ClienteModel({
    required this.objectId,
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
