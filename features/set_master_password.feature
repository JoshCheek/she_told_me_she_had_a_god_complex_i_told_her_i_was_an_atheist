Feature:
  In order to store our passwords
  We need one password to rule them all

  Scenario: Set the master password
    Given the stdin content "mah first pass"
    When I run "atheist --set"
    Then stdout includes "your master password has been set"
    And the exit status is 0

  Scenario: Reset the master password
    Given the stdin content "mah first pass"
    When I run "atheist --set"
    Then stdout includes "your master password has been set"
    Given the stdin content:
    """
    mah first pass
    mah second pass
    """
    When I run "atheist --set"
    Then stdout includes "enter your old passord: "
    And stdout includes "your master password has been set"
    And the exit status is 0

  Scenario: Failing to reset the master password
    Given the stdin content "mah first pass"
    When I run "atheist --set"
    Then stdout includes "your master password has been set"
    Given the stdin content "not mah first pass"
    When I run "atheist --set"
    Then stdout includes "enter your old passord: "
    And stderr includes "Incorrect master password"
    And the exit status is 1
