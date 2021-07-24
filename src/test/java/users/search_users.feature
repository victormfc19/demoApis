Feature: Search all users

  Background:
    * def urlBase = 'https://reqres.in/api/'
    * def people = read('../data/people.json')


  Scenario: Validate Get all users
    Given url urlBase+'users?page=2'
    When method GET
    Then status 200
    And match response.page == 2
    And match response.total == 12
    And match each response.data == {"id":#number,"email":'#string', "first_name":'#string',"last_name":'#string', "avatar":'#string' }


  Scenario: Validate user Morpheus
    * def parameters =
    """
    {
        "name": "morpheus",
        "job": "leader"
    }
    """
    Given url urlBase+'users'
    And request parameters
    When method POST
    Then status 201
    And match response.name == "morpheus"


  Scenario: Validate delete method
    Given url urlBase+'users/2'
    When method DELETE
    Then status 204


  Scenario: Validate register
    * def parameters =
    """
    {
       "email": "eve.holt@reqres.in",
       "password": "pistol"
    }
    """
    Given url urlBase+'register'
    And request parameters
    When method POST
    Then status 200
    And match response.id == 4
    And match response.token == "QpwL5tke4Pnpja7X4"


  Scenario Outline: Create <name> user with <job> job
    Given url urlBase+'users'
    And request {'name':'<name>', 'job':'<job>'}
    When method POST
    Then status 201
    And match response == {"name":'<name>', "job":"<job>", "id":'#string', "createdAt":'#ignore'}
    Examples:
    | people |

 Scenario: validate method PUT
   * def employee1 = people[0]
    Given url urlBase+'users/2'
    And request employee1
    When method PUT
    Then status 200
    And match response == {"name":'#(employee1.name)', "job":'#(employee1.job)', "updatedAt":#string}


