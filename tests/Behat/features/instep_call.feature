Feature: Call step in other step
  In order to mantain fluid step definition
  As a features writer
  I need to be able to call other steps from step body

  Background:
    Given a standard Behat project directory structure
    And a file named "features/support/env.php" with:
      """
      <?php
      require_once 'PHPUnit/Autoload.php';
      require_once 'PHPUnit/Framework/Assert/Functions.php';
      """
    And a file named "features/steps/calc_steps_en.php" with:
      """
      <?php
      $steps->Given('/I have entered "([^"]*)"/', function($world, $number) {
          $world->numbers[] = $number;
      });
      $steps->When('/I press +/', function($world) {
          $world->result  = array_sum($world->numbers);
          $world->numbers = array();
      });
      $steps->Then('/I should see "([^"]*)" on the screen/', function($world, $result) {
          assertEquals($result, $world->result);
      });
      """
    And a file named "features/steps/calc_steps_ru.php" with:
      """
      <?php
      $steps->Допустим('/Я ввел "([^"]*)"/', function($world, $number) use($steps) {
          $steps->Given("I have entered \"$number\"", $world);
      });
      $steps->Если('/Я нажму +/', function($world) use($steps) {
          $steps->When("I press +", $world);
      });
      $steps->Тогда('/Я должен увидеть на экране "([^"]*)"/', function($world, $result) use($steps) {
          $steps->Then("I should see \"$result\" on the screen", $world);
      });
      """

  Scenario:
    Given a file named "features/calc_en.feature" with:
      """
      Feature: Basic calculator
        Scenario:
          Given I have entered "12"
          And I have entered "27"
          And I have entered "5"
          When I press +
          Then I should see "44" on the screen
      """
    When I run "behat -TCf progress features/calc_en.feature"
    Then it should pass with:
      """
      .....
      
      1 scenario (1 passed)
      5 steps (5 passed)
      """      

  Scenario:
    Given a file named "features/calc_en.feature" with:
      """
      Feature: Basic calculator
        Scenario:
          Given I have entered "7"
          When I press +
          Then I should see "8" on the screen
      """
    When I run "behat -TCf progress features/calc_en.feature"
    Then it should fail with:
      """
      ..F
      
      (::) failed steps (::)
      
      01. Failed asserting that <integer:7> is equal to <string:8>.
          In step `Then I should see "8" on the screen'. # features/steps/calc_steps_en.php:11
          From scenario ***.                             # features/calc_en.feature:2
      
      1 scenario (1 failed)
      3 steps (2 passed, 1 failed)
      """

  Scenario:
    Given a file named "features/calc_ru.feature" with:
      """
      # language: ru
      Функционал: Стандартный калькулятор
        Сценарий:
          Допустим Я ввел "12"
          И Я ввел "27"
          Если Я нажму +
          То Я должен увидеть на экране "39"
      """
    When I run "behat -TCf progress features/calc_ru.feature"
    Then it should pass with:
      """
      ....
      
      1 scenario (1 passed)
      4 steps (4 passed)
      """      

  Scenario:
    Given a file named "features/calc_ru.feature" with:
      """
      # language: ru
      Функционал: Стандартный калькулятор
        Сценарий:
          Допустим Я ввел "7"
          Если Я нажму +
          То Я должен увидеть на экране "8"
      """
    When I run "behat -TCf progress features/calc_ru.feature"
    Then it should fail with:
      """
      ..F
      
      (::) failed steps (::)
      
      01. Failed asserting that <integer:7> is equal to <string:8>.
          In step `То Я должен увидеть на экране "8"'. # features/steps/calc_steps_ru.php:10
          From scenario ***.                           # features/calc_ru.feature:3
      
      1 scenario (1 failed)
      3 steps (2 passed, 1 failed)
      """
