module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class AddPassword
    Callable.call self, :interface

    def call
      # encrypted passwords data must exist
      encrypted_passwords = interface.retrieve_encrypted_passwords
      return interface.fail_cuz_you_have_no_encrypted_passwords unless encrypted_passwords

      # master password must be correct
      master_password = interface.master_password
      passwords       = Decrypt.call encrypted_passwords, master_password
      return interface.fail_cuz_your_master_password_is_wrong unless passwords

      # name must be valid
      name = interface.name
      return interface.fail_cuz_invalid_name if name.to_s.empty?

      # user must confirm override if name already exists
      return interface.fail_cuz_no_name_override if passwords[name] && !interface.should_override_name?

      # remove the part where we pass the name, the interface already has access to this
      login         = interface.login
      search_string = interface.search_string name # could hypothetically fail here
      password      = interface.password      name # could hypothetically fail here

      added_password = passwords.add name, 'password' => password, 'login' => login, 'search_string' => search_string

      encrypted_passwords = Encrypt.call passwords, master_password

      interface.persist_encrypted_passwords encrypted_passwords # could hypothetically fail here

      interface.succeed added_password
    end
  end
end
