Feature: Add a password

  To store passwords, we need to be able to add them to the password file

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
    Then stdout includes "enter your master password: "
    And  stdout includes "what is this a password for? "
    And  stdout includes "enter search words: "
    And  stdout includes "enter the password for gmail.com: "
    And  stdout includes "your password for 'gmail.com' is now being stored"
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
    Then stdout includes "enter your master password: "
    # And  stdout does not include "what is this a password for? " # need to add this to haiti
    And  stderr includes "incorrect master password"
    And the exit status is 1
    And my a password file contains
    | name    | password | search words |
    | my bank | abc123   | banking      |

  Scenario: Invalid name
    Given a password file with
    | name    | password | search words |
    | my bank | abc123   | banking      |
    Given the stdin content:
    """
    {{master_password}}


    """
    When I run "atheist --add"
    Then stdout includes "enter your master password: "
    And  stdout includes "what is this a password for? "
    # And  stdout does not include "enter search words: "
    And  stderr includes "invalid name"
    And the exit status is 1
    And my a password file contains
    | name    | password | search words |
    | my bank | abc123   | banking      |

  Scenario: Unintentional duplicate name
    Given a password file with
    | name    | password | search words |
    | my bank | abc123   | banking      |
    Given the stdin content:
    """
    {{master_password}}
    my bank
    n
    """
    When I run "atheist --add"
    Then stdout includes "enter your master password: "
    And  stdout includes "what is this a password for? "
    # And  stdout includes '"my bank" is already being stored, override it? (y/N) "
    # And  stdout does not include "enter search words: "
    And the exit status is 0
    And my a password file contains
    | name    | password | search words |
    | my bank | abc123   | banking      |

  Scenario: Unintentional duplicate name
    Given a password file with
    | name    | password | search words |
    | my bank | abc123   | banking      |
    Given the stdin content:
    """
    {{master_password}}
    my bank


    """
    When I run "atheist --add"
    Then stdout includes "enter your master password: "
    And  stdout includes "what is this a password for? "
    # And  stdout includes '"my bank" is already being stored, override it? (y/N) "
    # And  stdout does not include "enter search words: "
    And the exit status is 0
    And my a password file contains
    | name    | password | search words |
    | my bank | abc123   | banking      |

  @wip
  Scenario: Intentional duplicate name
    Given a password file with
    | name    | password | search words |
    | my bank | abc123   | banking      |
    Given the stdin content:
    """
    {{master_password}}
    my bank
    y
    money loans credit cards
    new password
    """
    When I run "atheist --add"
    Then stdout includes "enter your master password: "
    # And  stdout includes '"my bank" is already being stored, override it? (y/N) "
    And  stdout includes "what is this a password for? "
    And  stdout includes "enter search words: "
    And  stdout includes "enter the password for my bank: "
    And  stdout includes "your password for 'my bank' is now being stored"
    And the exit status is 0
    And my a password file contains
    | name      | password             | search words             |
    | my bank   | new password         | money loans credit cards |

  Scenario: No master password set
    Given I delete my password file
    When I run "atheist --add"
    Then stderr includes "there is no password file at {{password_filename.inspect}}, to create it, set the master password"
    # Then stdout does not include "enter your master password: "
    And the exit status is 1
    And there is no password file
