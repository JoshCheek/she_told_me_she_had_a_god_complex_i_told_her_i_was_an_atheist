Feature: Retrieve a password

  So I got mah passwords stored, but what good is that?
  I gotta get em back out, too, so I can use them.

  Background:
    Given a password file with
    | name    | password | search words |
    | my bank | abc123   | banking      |
    | my mail | def456   | email        |

  Scenario: No master password set
    Given I delete my password file
    When I run "atheist anything"
    Then stderr includes "there is no password file at {{password_filename.inspect}}, to create it, set the master password"
    # Then stdout does not include "enter your master password: "
    And the exit status is 1
    And there is no password file

  Scenario: Incorrect master password
    Given the stdin content "wrong master password"
    When I run "atheist matches nothing"
    Then stdout includes "enter your master password: "
    And  stderr includes "incorrect master password"
    And the exit status is 1
    Given a password file with
    | name    | password | search words |
    | my bank | abc123   | banking      |
    | my mail | def456   | email        |

  @wip
  Scenario: entering the name of the password
    Given the stdin content:
    """
    {{master_password}}
    my bank
    """
    When I run "atheist my bank"
    Then stdout includes "enter your master password: "
    And  stdout includes "'my bank' was copied to your clipboard"

  @not-implemented
  Scenario: entering a search word for the password
    Given the stdin content:
    """
    {{master_password}}
    my bank
    """
    When I run "atheist my bank"
    Then stdout includes "enter your master password: "
    And  stdout includes "'my bank' was copied to your clipboard"

  Scenario: entering ambiguous search words (matches two passwords)
  Scenario: entering a phrase that matches nothing
