class CepModel {
  String? cep;
  String? logradouro;
  String? bairro;
  String? localidade;
  CepModel({
    this.cep,
    this.logradouro,
    this.bairro,
    this.localidade,
  });

  CepModel.fromJson(Map<String, dynamic> json) {
    cep = json['cep'];
    logradouro = json['logradouro'];
    bairro = json['bairro'];
    localidade = json['localidade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cep'] = cep;
    data['logradouro'] = logradouro;
    data['bairro'] = bairro;
    data['localidade'] = localidade;
    return data;
  }
}
