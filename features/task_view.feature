Features: Task view

  In order to perform tasks
  As a user of Singleshot
  I need a UI to view and act on individual tasks

  Background:
    Given the person john
    And the person scott

  Scenario: Claim task
    Given the task
      """
      title: "Absence request"
      potential_owners:
      - scott
      - john
      """
    When I login
    And I go to the task "Absence request"
    And I press "Claim"
    Then I should be on the task "Absence request"
    And the task "Absence request" should be active
    And the task "Absence request" should be owned by john

  Scenario: Cancel task
    Given the task
      """
      title: "Absence request"
      owner: john
      supervisors:
      - scott
      - john
      """
    When I login
    And I go to the task "Absence request"
    And I press "Cancel"
    Then I should be on the tasks list
    And the task "Absence request" should be cancelled
