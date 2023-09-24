class Back4AppModel {
  List<Results>? results;

  Back4AppModel({this.results});

  Back4AppModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String? objectId;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? email;
  String? password;
  Address? address;

  Results(
      {this.objectId,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.email,
      this.password,
      this.address});

  Results.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    return data;
  }
}

class Address {
  String? cep;
  String? city;
  String? road;
  String? bairro;
  String? client;
  String? number;

  Address(
      {this.cep, this.city, this.road, this.bairro, this.client, this.number});

  Address.fromJson(Map<String, dynamic> json) {
    cep = json['cep'];
    city = json['city'];
    road = json['road'];
    bairro = json['bairro'];
    client = json['client'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cep'] = cep;
    data['city'] = city;
    data['road'] = road;
    data['bairro'] = bairro;
    data['client'] = client;
    data['number'] = number;
    return data;
  }
}