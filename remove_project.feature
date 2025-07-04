Feature: Remove project
# O objetivo desta funcionalidade é descrever o comportamento da remoção de projetos. 
# Nesse caso, assumindo que o terraplaner tenha a funcionalidade de backend remove_project.
# Descreve o cenário de sucesso, as validações de segurança e a integridade dos dados enviados.

  #----------------------------------------------------------------------------------------------------
  # Objetivo: Validar o cenário de sucesso.
  # Descrição: Este teste verifica se um usuário devidamente autenticado pode remover um projeto ao
  # fornecer os dados corretos. A expectativa é uma resposta de sucesso (código 200) com uma
  # mensagem confirmando e validando o fluxo da funcionalidade.
  #----------------------------------------------------------------------------------------------------
  Scenario: A remoção foi realizada com sucesso
    Given um cabeçalho "Authorization" com valor "token11111"
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
  # Objetivo: Validar a robustez da API contra dados nulos em campos obrigatórios.
  # Descrição: Teste para visualizar a reação da API quando um campo essencial como 'projectId' é enviado como nulo.
  # A resposta correta é um erro 400 (Bad Request), indicando que a requisição do cliente é inválida,
  # e deve vir acompanhada de uma mensagem sobre o campo problemático.
  #----------------------------------------------------------------------------------------------------
  Scenario: Campo no corpo com valor nulo
    Given um cabeçalho "Authorization" com valor "token1"
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
    Given um cabeçalho "Authorization" com valor "token11"
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
  #----------------------------------------------------------------------------------------------------
  # Objetivo: Validar a lógica de confirmação da remoção.
  # Descrição: Este teste garante que a remoção de um projeto não ocorra se o campo 'confirm'
  # for 'false'. A API deve retornar um erro (código 400), prevenindo
  # exclusões acidentais.
  #----------------------------------------------------------------------------------------------------
  Scenario: Remoção não confirmada
    Given um cabeçalho "Authorization" com valor "token111"
    And um corpo com o nome "json_data" contendo:
    """
    {
      "projectId": "111",
      "confirm": false
    }
    """
    When uma requisicao de "POST" é enviada para "/RemoveProject"
    Then a resposta deve ter o codigo 400
    And o corpo deve conter:
    """
    {
      "message": "A remoção do projeto não foi confirmada"
    }
    """

  #----------------------------------------------------------------------------------------------------
  # Objetivo: Validar a resposta para um recurso não encontrado.
  # Descrição: Este teste verifica se a API retorna o código 404 (Not Found) ao tentar remover um
  # projeto com um ID que não existe. Isso demonstra o tratamento correto de integridade de dados.
  #----------------------------------------------------------------------------------------------------
Scenario: Tentativa de remoção de um projeto inexistente
    Given um cabeçalho "Authorization" com valor "token7"
    And um corpo com o nome "json_data" contendo:
    """
    {
      "projectId": "7777777",
      "confirm": true
    }
    """
    When uma requisicao de "POST" é enviada para "/RemoveProject"
    Then a resposta deve ter o codigo 404
    And o corpo deve conter:
    """
    {
      "message": "Projeto com o ID 7777777 não encontrado"
    }
    """
