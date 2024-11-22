class Cliente {
  int? id;
  String nome;
  String sobrenome;
  String email;
  int idade;
  String? foto;

  Cliente({
    this.id,
    required this.nome,
    required this.sobrenome,
    required this.email,
    required this.idade,
    this.foto,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nome: json['nome'],
      sobrenome: json['sobrenome'],
      email: json['email'],
      idade: json['idade'],
      foto: json['foto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'sobrenome': sobrenome,
      'email': email,
      'idade': idade,
      'foto': foto,
    };
  }
}
