Feature: Retrieve a password

  So I got mah passwords stored, but what good is that?
  I gotta get em back out, too, so I can use them.

  Background:
    Given a password file with
    | name     | login      | password  | search words |
    | my bank  | bank_login | bank pass | banking      |
    | my mail  | mail_login | mail pass | email        |

  Scenario: No master password set
    Given I delete my password file
    When I run "atheist anything"
    Then stderr includes "there is no password file at {{password_filename.inspect}}, to create it, set the master password"
    # Then stdout does not include "enter your master password: "
    And the exit status is 1
    And there is no password file

  Scenario: Incorrect master password
    Given the stdin content "wrong master password"
    When I run "atheist anything"
    Then stdout includes "enter your master password: "
    And  stderr includes "incorrect master password"
    And the exit status is 1

  Scenario: entering a phrase that matches
    Given the stdin content "{{master_password}}"
    When I run "atheist bank"
    Then  stdout includes "'my bank' was copied to your clipboard"
    And   stdout includes "login: 'bank_login'"
    And  "bank pass" was copied to my clipboard
    And the exit status is 0

  Scenario: multiple matches
    Given the stdin content "{{master_password}}"
    When I run "atheist my"
    And  stderr includes "'my' matched: 'my bank', 'my mail'"
    And the exit status is 1

  Scenario: entering a phrase that matches nothing
    Given the stdin content "{{master_password}}"
    When I run "atheist I MATCH THE NOTHING"
    And  stderr includes "'I MATCH THE NOTHING' matched nothing"
    And the exit status is 1
