Feature: Add a password

  To store passwords, we need to be able to add them to the password file

  @wip
  Scenario: Add the password
    Given a password file with
    | name    | password | search words |
    | my bank | abc123   | banking      |
    Given the stdin content:
    """
    {{master_password}}
    gmail.com
    email mail gmail google
    elivSZOK75b5ZFjD5fTi
    """
    When I run "atheist --add"
    # the {{' '}} is b/c vim will automatically strip trailing whitespace
    Then stdout is:
    """
    enter your master password:{{' '}}
    what is this a password for?{{' '}}
    enter search words:{{' '}}
    enter the password for gmail.com:{{' '}}
    Your password for "gmail.com" is now being stored
    """
    And the exit status is 0
    And my a password file contains
    | name      | password             | search words            |
    | my bank   | abc123               | banking                 |
    | gmail.com | elivSZOK75b5ZFjD5fTi | email mail gmail google |

  Scenario: Incorrect master password
    Given a password file with
    | name    | password | search words |
    | my bank | abc123   | banking      |
    Given the stdin content "wrong master password"
    When I run "atheist --add"
    Then stdout is:
    """
    enter your master password:{{' '}}
    incorrect master password
    """
    And my a password file contains
    | name      | password             | search words            |
    | my bank   | abc123               | banking                 |

  Scenario: Invalid name
  Scenario: Duplicate name
  Scenario: No master password set
