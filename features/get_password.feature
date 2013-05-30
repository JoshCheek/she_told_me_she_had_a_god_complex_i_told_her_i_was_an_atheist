Feature: Retrieve a password

  So I got mah passwords stored, but what good is that?
  I gotta get em back out, too, so I can use them.

  Background:
    Given a password file with
    | name                     | password  | search words |
    | bank                     | bank pass | banking      |
    | mail                     | mail pass | email        |
    | conflicting search words | whatev    | mail bank    |

  @wip
  Scenario: No master password set
    Given I delete my password file
    When I run "atheist anything"
    Then stderr includes "there is no password file at {{password_filename.inspect}}, to create it, set the master password"
    # Then stdout does not include "enter your master password: "
    And the exit status is 1
    And there is no password file

  @wip
  Scenario: Incorrect master password
    Given the stdin content "wrong master password"
    When I run "atheist matches nothing"
    Then stdout includes "enter your master password: "
    And  stderr includes "incorrect master password"
    And the exit status is 1

  @wip
  Scenario: entering the name of the password
    Given the stdin content:
    """
    {{master_password}}
    bank
    """
    When I run "atheist bank"
    Then stdout includes "enter your master password: "
    And  stdout includes "'bank' was copied to your clipboard"
    And  "bank pass" was copied to my clipboard

  @not-implemented
  Scenario: entering a search word for the password
    Given the stdin content:
    """
    {{master_password}}
    bank
    """
    When I run "atheist mail"
    Then stdout includes "enter your master password: "
    And  stdout includes "'bank' was copied to your clipboard"
    And  "mail pass" was copied to my clipboard

  Scenario: entering ambiguous search words (matches two passwords)
  Scenario: entering a phrase that matches nothing
