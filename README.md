# CRUD App - Clientes e Produtos

Bem-vindo ao **CRUD App**, uma aplicação Flutter para gerenciar Clientes e Produtos. Este projeto permite realizar operações de **Criação**, **Leitura**, **Atualização** e **Remoção** (CRUD) em clientes e produtos, integrando-se com uma API RESTful em `localhost:4000`.

## Índice

- [Descrição do Projeto](#descrição-do-projeto)
- [Funcionalidades](#funcionalidades)
- [Estrutura do Projeto](#estrutura-do-projeto)
  - [lib/](#lib)
    - [models/](#models)r
    - [services/](#services)
    - [screens/](#screens)
    - [widgets/](#widgets)
    - [main.dart](#maindart)
  - [pubspec.yaml](#pubspecyaml)
- [Instalação e Configuração](#instalação-e-configuração)
  - [Pré-requisitos](#pré-requisitos)
  - [Passos para Configuração](#passos-para-configuração)
- [Como Executar](#como-executar)
- [Detalhamento dos Arquivos](#detalhamento-dos-arquivos)
  - [Modelos](#modelos)
  - [Serviços de API](#serviços-de-api)
  - [Telas](#telas)
  - [Widgets](#widgets)
  - [Dependências](#dependências)
- [Validação de Campos](#validação-de-campos)
- [Aparência e Usabilidade](#aparência-e-usabilidade)

---

## Descrição do Projeto

Este projeto é uma aplicação Flutter que permite gerenciar uma lista de clientes e produtos, realizando operações de CRUD através de uma interface facil de usar. A aplicação se comunica com uma API backend hospedada em `localhost:4000`.

## Funcionalidades

### Clientes

- **Atributos**: `id`, `nome`, `sobrenome`, `email`, `idade`, `foto`.
- **Operações**:
  - **Listar Clientes**: Exibe uma lista de clientes cadastrados.
  - **Adicionar Cliente**: Formulário para cadastrar um novo cliente com validação de campos.
  - **Editar Cliente**: Atualiza as informações de um cliente existente.
  - **Remover Cliente**: Exclui um cliente da lista.

### Produtos

- **Atributos**: `id`, `nome`, `descricao`, `preco`, `data_atualizado`.
- **Operações**:
  - **Listar Produtos**: Exibe uma lista de produtos cadastrados.
  - **Adicionar Produto**: Formulário para cadastrar um novo produto com validação de campos.
  - **Editar Produto**: Atualiza as informações de um produto existente.
  - **Remover Produto**: Exclui um produto da lista.

## Estrutura do Projeto

O projeto está organizado em várias pastas para separar as diferentes camadas da aplicação.

### lib/

Contém todo o código Dart da aplicação.

#### models/

Contém as classes de modelo que representam os dados de Clientes e Produtos.

- **cliente.dart**
- **produto.dart**

#### services/

Contém as classes que interagem com a API RESTful.

- **api_service.dart**

#### screens/

Contém as telas principais da aplicação.

- **home_screen.dart**: Tela inicial com opções de navegação.
- **clientes_screen.dart**: Tela para listar e gerenciar clientes.
- **produtos_screen.dart**: Tela para listar e gerenciar produtos.
- **cliente_form_screen.dart**: Formulário para adicionar ou editar clientes.
- **produto_form_screen.dart**: Formulário para adicionar ou editar produtos.

#### widgets/

Pode conter widgets personalizados e reutilizáveis (opcional, dependendo da implementação).

#### main.dart

Arquivo principal que inicia a aplicação.

### pubspec.yaml

Arquivo de configuração do projeto, onde são definidas as dependências e assets.

## Instalação e Configuração

### Pré-requisitos

- **Flutter SDK**: Certifique-se de ter o Flutter instalado em sua máquina.
- **Dart SDK**: Geralmente vem com o Flutter.
- **API Backend**: Uma API RESTful rodando em `localhost:4000` que gerencia clientes e produtos.

### Passos para Configuração

1. **Clone o Repositório (caso não tenha o arquivo .zip)**

   ```bash
   git clone https://github.com/seu-usuario/crud_app.git
   ```

2. **Navegue até o Diretório do Projeto**

   ```bash
   cd crud_app
   ```

3. **Instale as Dependências**

   ```bash
   flutter pub get
   ```

4. **Configure a API Backend**

   Certifique-se de que a API está rodando em `localhost:4000` e que as rotas `/clientes` e `/produtos` estão funcionando.

## Como Executar

1. **Inicie o Emulador ou Conecte um Dispositivo Físico**

2. **Execute o Aplicativo**

   ```bash
   flutter run
   ```

3. **Interaja com a Aplicação**

   - Use o menu de navegação para acessar as telas de Clientes e Produtos.
   - Adicione, edite ou remova clientes e produtos conforme necessário.

## Detalhamento dos Arquivos

### Modelos

#### cliente.dart

```dart
class Cliente {
  int? id;
  String nome;
  String sobrenome;
  String email;
  int idade;
  String? foto;

  // Construtor, métodos fromJson e toJson
}
```

- Representa o modelo de um cliente.
- Inclui métodos para serialização e desserialização JSON.

#### produto.dart

```dart
class Produto {
  int? id;
  String nome;
  String descricao;
  double preco;
  String? dataAtualizado;

  // Construtor, métodos fromJson e toJson
}
```

- Representa o modelo de um produto.
- Inclui métodos para serialização e desserialização JSON.

### Serviços de API

#### api_service.dart

- **Responsável pela comunicação com a API backend.**
- Métodos para:
  - **Clientes**:
    - `fetchClientes()`
    - `createCliente(Cliente cliente)`
    - `updateCliente(Cliente cliente)`
    - `deleteCliente(int id)`
  - **Produtos**:
    - `fetchProdutos()`
    - `createProduto(Produto produto)`
    - `updateProduto(Produto produto)`
    - `deleteProduto(int id)`

### Telas

#### main.dart

- Ponto de entrada da aplicação.
- Define o tema e a rota inicial (`HomeScreen`).

#### home_screen.dart

- Tela inicial com um `Drawer` para navegação.
- Opções para acessar as telas de Clientes e Produtos.

#### clientes_screen.dart

- Exibe uma lista de clientes.
- Botão flutuante para adicionar novo cliente.
- Permite editar ou excluir um cliente existente.

#### cliente_form_screen.dart

- Formulário para adicionar ou editar clientes.
- Campos com validação:
  - Nome
  - Sobrenome
  - Email
  - Idade
  - Foto (URL opcional)

#### produtos_screen.dart

- Exibe uma lista de produtos.
- Botão flutuante para adicionar novo produto.
- Permite editar ou excluir um produto existente.

#### produto_form_screen.dart

- Formulário para adicionar ou editar produtos.
- Campos com validação:
  - Nome
  - Descrição
  - Preço

### Widgets

- **Customizados conforme necessário.**
- Podem incluir componentes reutilizáveis como botões, campos de entrada, etc.

### Dependências

#### pubspec.yaml

```yaml
name: crud_app
description: A Flutter CRUD application for Clientes and Produtos.

version: 1.0.0+1

environment:
  sdk: ">=2.12.0 <3.0.0"

dependencies:
  flutter:
    sdk: flutter
  http: ^0.13.5
  email_validator: ^2.0.1
  flutter_staggered_animations: ^1.0.0
  cached_network_image: ^3.2.1

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true
```

## Validação de Campos

### Clientes

- **Nome e Sobrenome**:
  - Não podem ser vazios.
  - Devem ter entre 3 e 25 caracteres.
- **Email**:
  - Deve ser um email válido.
- **Idade**:
  - Número positivo menor que 120.
- **Foto**:
  - Opcional.
  - Se fornecido, deve ser uma URL válida.

### Produtos

- **Nome e Descrição**:
  - Não podem ser vazios.
  - Devem ter entre 3 e 25 caracteres.
- **Preço**:
  - Número positivo.

