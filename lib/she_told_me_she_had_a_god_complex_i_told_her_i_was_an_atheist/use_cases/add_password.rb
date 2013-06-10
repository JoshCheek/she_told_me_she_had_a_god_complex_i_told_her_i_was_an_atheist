module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  module UseCases
    class AddPassword
      Callable.call self, :interaction

      def call
        # encrypted passwords data must exist
        encrypted_passwords = interaction.retrieve_encrypted_passwords
        return interaction.fail_cuz_you_have_no_encrypted_passwords unless encrypted_passwords

        # master password must be correct
        master_password = interaction.master_password
        passwords       = Decrypt.call encrypted_passwords, master_password
        return interaction.fail_cuz_your_master_password_is_wrong unless passwords

        # name must be valid
        name = interaction.name
        return interaction.fail_cuz_invalid_name if name.to_s.empty?

        # user must confirm override if name already exists
        return interaction.fail_cuz_no_name_override if passwords[name] && !interaction.should_override_name?

        # remove the part where we pass the name, the interaction already has access to this
        login         = interaction.login
        search_string = interaction.search_string name # could hypothetically fail here
        password      = interaction.password      name # could hypothetically fail here

        added_password = passwords.add name, 'password' => password, 'login' => login, 'search_string' => search_string

        encrypted_passwords = Encrypt.call passwords, master_password

        interaction.persist_encrypted_passwords encrypted_passwords # could hypothetically fail here

        interaction.succeed added_password
      end
    end
  end
end
