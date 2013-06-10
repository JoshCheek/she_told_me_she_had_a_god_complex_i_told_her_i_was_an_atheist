Feature: Set the master password

  To store our passwords, we need one password to rule them all

  Scenario: Set the master password
    Given the stdin content:
    """
    mah first pass
    mah first pass
    """
    When I run "atheist --set"
    Then stdout includes "your master password has been set"
    And the exit status is 0

  Scenario: Failing to confirm master password
    Given the stdin content:
    """
    mah first pass
    not mah first pass
    """
    When I run "atheist --set"
    Then stderr includes "confirmation does not match"
    And the exit status is 1

  # later on, switch this over to use "Given a password file with"
  Scenario: Reset the master password
    Given the stdin content:
    """
    mah first pass
    mah first pass
    """
    When I run "atheist --set"
    Then stdout includes "your master password has been set"
    Given the stdin content:
    """
    mah first pass
    mah second pass
    mah second pass
    """
    When I run "atheist --set"
    Then stdout includes "enter your old passord: "
    And stdout includes "your master password has been set"
    And the exit status is 0

  # later on, switch this over to use "Given a password file with"
  Scenario: Failing to reset the master password due to incorrect old master password
    Given the stdin content:
    """
    mah first pass
    mah first pass
    """
    When I run "atheist --set"
    Then stdout includes "your master password has been set"
    Given the stdin content "not mah first pass"
    When I run "atheist --set"
    Then stdout includes "enter your old passord: "
    And stderr includes "incorrect master password"
    And the exit status is 1

  Scenario: Failing to reset the master password due to incorrect confirmation
    Given the stdin content:
    """
    mah first pass
    mah first pass
    """
    When I run "atheist --set"
    Then stdout includes "your master password has been set"
    Given the stdin content:
    """
    mah first pass
    mah second pass
    not mah second pass
    """
    When I run "atheist --set"
    Then stdout includes "enter your old passord: "
    And stderr includes "confirmation does not match"
    And the exit status is 1
