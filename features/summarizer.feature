Feature: Summarizer Base

  Scenario: Table with a section for each month
    Given I need sub-totals for each month
    When I call `Foo::find_with_sums`
    #Then I should see a table with sub-totals
    Then `each_with_sums` should return correct values

  Scenario: Table with a section for every letter in the alphabet
    Given I need sub-totals for each letter in the alphabet for `name`
    When I call `Foo::find_with_sums`
    #Then I should see a table with sub-totals
    Then `each_with_sums` should return correct values

  Scenario: Table with a section for each `belongs_to` entity `Bar`
    Given I need sub-totals for each different bar
    When I call `Foo::find_with_sums`
    #Then I should see a table with sub-totals
    Then `each_with_sums` should return correct values
