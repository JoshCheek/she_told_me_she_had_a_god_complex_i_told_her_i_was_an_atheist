She told me she had a god complex, I told her I was an atheist
==============================================================

I didn't actually tell her I was an atheist,
I actually told her I had an honesty complex and that I was scared of her.
I kept this name because I thought it was catchy, but I'm telling you the
truth before telling you what this gem does, b/c, as you now know,
I have an honesty complex.

Anyway, there's 1pass and lastpass and all that shit, but you have to give them money
and they're all web based or whatever.

I might be bad at life, but I'm pretty fucking good at reinventing wheels,
so I figured "fuck it, lets do this". This is probably insecure (wink),
you'll probably lose all your passwords to the hackahz. If you're a security
guru, feel free to poke holes in this and tell me what I need to do to fix it.


Installation
------------

    gem install she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist


Usage
-----

*NOTE* None of the places where I show your password will actually show you the password,
that's just to make it easier to understand.

set a master password

    $ atheist --set
    enter your new master password: omghi # note this won't actually display

Store a new password for gmail.com

    $ atheist --add
    enter your master password: mahpass
    what is this a password for? gmail.com
    enter search words: email mail gmail google
    enter the password for gmail.com: elivSZOK75b5ZFjD5fTi
    Your password for "gmail.com" is now being stored

Retrieve a password for gmail.com

    $ atheist gmail
    enter your master password: mahpass
    Your password for "google.com" has been saved to your clipboard

Retrieve a password based on search words

    $ atheist mail
    Ambiguous passwords, please add more search words

    $ atheist mail google
    enter your master password: mahpass
    Your password for "google.com" has been saved to your clipboard

List names we have passwords for

    $ atheist --list
    Enter your master password: mahpass

Cool features I'll probably never add
-------------------------------------

* When overriding, state old values above prompt for new
* Confirm passwords
* Set a time limit with which the master password is not needed (uhm, I think this means keep a process running in the bg that has the unencrypted file loaded, then always check for like a pid or something to talk to it and ask it for the password.)
* Generate passwords given constraints
* Rename lib
* Remove `subset_true` on surrogate

License
-------

           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                       Version 2, December 2004

    Copyright (C) 2013 Josh Cheek <josh.cheek@gmail.com>

    Everyone is permitted to copy and distribute verbatim or modified
    copies of this license document, and changing it is allowed as long
    as the name is changed.

               DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
      TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

      0. You just DO WHAT THE FUCK YOU WANT TO.


