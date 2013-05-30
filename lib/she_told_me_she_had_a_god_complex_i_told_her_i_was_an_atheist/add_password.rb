module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class AddPassword
    Callable.call self, :interface

    # this is actually the logic behind AddPassword,
    # figure out later how we want to deal with the multiple use cases
    def call
      # encrypted passwords data must exist
      encrypted_file = interface.retrieve_encrypted_file
      return interface.fail_cuz_you_need_a_password_file unless encrypted_file

      # master password must be correct
      master_password = interface.master_password
      passwords       = Decrypt.call encrypted_file, master_password
      return interface.fail_cuz_your_master_password_is_wrong unless passwords

      # name must be valid
      name = interface.get_name
      return interface.fail_cuz_invalid_name if name.to_s.empty?

      # user must confirm override if name already exists
      return interface.fail_cuz_no_name_override if passwords[name] && !interface.should_override_name?

      search_words = interface.get_search_words name # could hypothetically fail here
      password     = interface.get_password     name # could hypothetically fail here

      passwords.add name, 'password' => password, 'search_words' => search_words

      encrypted_file = Encrypt.call passwords, master_password

      interface.persist_encrypted_file encrypted_file # could hypothetically fail here

      interface.success
    end
  end
end
