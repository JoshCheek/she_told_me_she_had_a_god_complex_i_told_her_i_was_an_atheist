Feature: Set the master password

  To store our passwords, we need one password to rule them all

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

  # later on, switch this over to use "Given a password file with"
  Scenario: Failing to reset the master password
    Given the stdin content "mah first pass"
    When I run "atheist --set"
    Then stdout includes "your master password has been set"
    Given the stdin content "not mah first pass"
    When I run "atheist --set"
    Then stdout includes "enter your old passord: "
    And stderr includes "Incorrect master password"
    And the exit status is 1
