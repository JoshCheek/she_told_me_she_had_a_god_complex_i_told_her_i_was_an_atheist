Feature:
  In order to store our passwords
  We need one password to rule them all

  Scenario: Set the master password
    Given I respond "mah first pass" when prompted for "new master password"
    When I run "atheist --set"
    Then stdout includes "Your master password has been set"
    And the exit status is 0

  Scenario: Reset the master password
    Given I respond "mah first pass" when prompted for "new master password"
    When I run "atheist --set"
    Then stdout includes "Your master password has been set"
    Given I respond "mah first pass" when prompted for "old master password"
    Given I respond "mah second pass" when prompted for "new master password"
    When I run "atheist --set"
    Then stdout includes "Your master password has been set"
    And the exit status is 0

  Scenario: Failing to reset the master password
    Given I respond "mah first pass" when prompted for "new master password"
    When I run "atheist --set"
    Then stdout includes "Your master password has been set"
    Given I respond "not mah first pass" when prompted for "old master password"
    When I run "atheist --set"
    Then stdout includes "Incorrect master password"
    And the exit status is 1
