Feature: Summarizer Base

  Scenario:
    Given I need sub-totals for each month,
    When I call `Foo::find_with_sums`
    And I use `each_with_sums`
    Then I should see a table with sub-totals
