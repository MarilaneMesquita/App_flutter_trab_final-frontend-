class Produto {
  int? id;
  String nome;
  String descricao;
  double preco;
  String? dataAtualizado;

  Produto({
    this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    this.dataAtualizado,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      preco: json['preco'].toDouble(),
      dataAtualizado: json['data_atualizado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
    };
  }
}
