module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  module UseCases
    class ListPassword
      Callable.call self, :interaction

      def call
        # encrypted passwords data must exist
        encrypted_passwords = interaction.retrieve_encrypted_passwords
        return interaction.fail_cuz_you_have_no_encrypted_passwords unless encrypted_passwords

        # master password must be correct
        master_password = interaction.master_password
        passwords       = Decrypt.call encrypted_passwords, master_password
        return interaction.fail_cuz_your_master_password_is_wrong unless passwords

        interaction.list_passwords passwords
        interaction.succeed
      end
    end
  end
end
