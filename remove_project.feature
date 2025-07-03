Feature: Remove project
# O objetivo desta funcionalidade é descrever o comportamento da remoção de projetos.
# Descreve o cenário de sucesso, as validações de segurança e a integridade dos dados enviados.

  #----------------------------------------------------------------------------------------------------
  # Objetivo: Validar o cenário de sucesso.
  # Descrição: Este teste verifica se um usuário devidamente autenticado pode remover um projeto ao
  # fornecer os dados corretos. A expectativa é uma resposta de sucesso (código 200) com uma
  # mensagem confirmando e validando o fluxo da funcionalidade.
  #----------------------------------------------------------------------------------------------------
  Scenario: A remoção foi realizada com sucesso
    Given um cabeçalho "Authorization" com valor "tokenvalido1"
    And um corpo com o nome "json_data" contendo:
    """
    {
      "projectId": "111",
      "confirm": true
    }
    """
    When uma requisicao de "POST" é enviada para "/RemoveProject"
    Then a resposta deve ter o codigo 200
    And o corpo deve conter:
    """
    {
      "message": "Projeto 111 removido com sucesso"
    }
    """

  #----------------------------------------------------------------------------------------------------
  # Objetivo: Validar a camada de segurança (autenticação).
  # Descrição: Este cenário assegura que o endpoint não pode ser acessado por usuários não autenticados.
  # Ao enviar uma requisição sem o token de autorização, a API deve retornar o código 401 (Unauthorized),
  # protegendo a ação contra acessos indevidos.
  #----------------------------------------------------------------------------------------------------
  Scenario: Campo do cabeçalho faltando
    Given um corpo com o nome "json_data" contendo:
    """
    {
      "projectId": "111",
      "confirm": true
    }
    """
    When uma requisicao de "POST" é enviada para "/RemoveProject"
    Then a resposta deve ter o codigo 401
    And o corpo deve conter:
    """
    {
      "message": "Cabeçalho de autorização ausente"
    }
    """

  #----------------------------------------------------------------------------------------------------
  # Objetivo: Validar a robustez da API contra dados nulos em campos obrigatórios.
  # Descrição: Teste para visualizar a reação da API quando um campo essencial como 'projectId' é enviado como nulo.
  # A resposta correta é um erro 400 (Bad Request), indicando que a requisição do cliente é inválida,
  # e deve vir acompanhada de uma mensagem clara sobre o campo problemático.
  #----------------------------------------------------------------------------------------------------
  Scenario: Campo no corpo com valor nulo
    Given um cabeçalho "Authorization" com valor "token_valido1"
    And um corpo com o nome "json_data" contendo:
    """
    {
      "projectId": null,
      "confirm": true
    }
    """
    When uma requisicao de "POST" é enviada para "/RemoveProject"
    Then a resposta deve ter o codigo 400
    And o corpo deve conter:
    """
    {
      "message": "O campo projectId não pode ser nulo"
    }
    """

  #----------------------------------------------------------------------------------------------------
  # Objetivo: Validar o tratamento de tipos de dados incorretos.
  # Descrição: Este teste envia um valor com formato inadequado para o 'projectId' (um texto onde se espera
  # um ID numérico, por exemplo). A API deve identificar essa inconsistência e retornar
  # um erro 400 (Bad Request) com uma mensagem específica sobre o formato inválido.
  #----------------------------------------------------------------------------------------------------
  Scenario: Campo no corpo com tipo inválido
    Given um cabeçalho "Authorization" com valor "token_valido1"
    And um corpo com o nome "json_data" contendo:
    """
    {
      "projectId": "idtexto",
      "confirm": true
    }
    """
    When uma requisicao de "POST" é enviada para "/RemoveProject"
    Then a resposta deve ter o codigo 400
    And o corpo deve conter:
    """
    {
      "message": "Formato de projectId inválido"
    }
    """