Feature: List the passwords

  Sometimes I forget what passwords I'm storing
  Or what search words I can use to select them
  So I need to list em out

  Background:
    Given a password file with
    | name     | login      | password  | search words |
    | my bank  | bank_login | bank pass | banking      |
    | my mail  | mail_login | mail pass | email        |

  Scenario: No master password set
    Given I delete my password file
    When I run "atheist --list"
    Then stderr includes "there is no password file at {{password_filename.inspect}}, to create it, set the master password"
    # Then stdout does not include "enter your master password: "
    And the exit status is 1
    And there is no password file

  Scenario: Incorrect master password
    Given the stdin content "wrong master password"
    When I run "atheist --list"
    Then stdout includes "enter your master password: "
    And  stderr includes "incorrect master password"
    And the exit status is 1

  Scenario: Listing with multiple passwords
    Given the stdin content "{{master_password}}"
    When I run "atheist --list"
    Then stdout includes "my bank"
    Then stdout includes "bank_login"
    Then stdout includes "banking"
    Then stdout includes "my mail"
    Then stdout does not include "bank pass"

  Scenario: Listing with no passwords
    Given a password file with
    | name     | login      | password  | search words |
    And  the stdin content "{{master_password}}"
    When I run "atheist --list"
    Then stderr includes "no passwords to list"
