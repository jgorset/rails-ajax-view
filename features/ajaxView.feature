Feature: Ajax View Processing
  In order to built ajax application
    As a django developer
    I want to use django ajax tags

  Scenario: Visit home page
    Given I access the url "/"
    Then I see "The base template for example app of using rails-ajax-view project"
    
  Scenario: Visit link
    Given I access the url "/#/tab1/#/tab3"
    Then I see "TAB1 CONTENT"
    And I see "TAB3 CONTENT"
  
  Scenario: Click on the link
    Given I access the url "/"
    When I click on the elem "tab1"
    Then I see "TAB1 CONTENT"
    And The url address is equal to "/#/tab1"
  
  Scenario: Click on the button
    Given I access the url "/"
    When I click on the elem "button1"
    Then I see "BUTTON1 CONTENT"
  
  Scenario: Click on the button with replacing content
    Given I access the url "/"
    When I click on the elem "button2"
    Then I see "BUTTON2 CONTENT"
    And I do not see "button_2"
  
  Scenario: Click on history buttin
    Given I access the url "/"
    When I click on the elem "tab1"
    And I see "TAB1 CONTENT"
    And I click history back button
    Then I do not see "TAB1 CONTENT"
  
  Scenario: Click on the link with confilcted container
    Given I access the url "/#/tab2/#/tab1/#/tab5"
    And I see "TAB1 CONTENT"
    And I see "TAB5 CONTENT"
    When I click on the elem "tab3" 
    Then I do not see "TAB5 CONTENT"
    And I see "TAB1 CONTENT"
    And I see "TAB3 CONTENT"