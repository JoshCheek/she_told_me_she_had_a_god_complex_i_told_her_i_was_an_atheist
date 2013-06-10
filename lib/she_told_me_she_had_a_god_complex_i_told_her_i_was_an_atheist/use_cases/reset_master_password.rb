module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  module UseCases
    class ResetMasterPassword
      Callable.call self, :interaction

      def call
        # this doesn't handle the case where there is no password file
        decrypted_passwords = Decrypt.call interaction.retrieve_encrypted_passwords, interaction.old_master_password
        if decrypted_passwords
          encrypted_passwords = Encrypt.call decrypted_passwords, interaction.new_master_password
          interaction.persist_encrypted_passwords encrypted_passwords
          interaction.succeed
        else
          interaction.fail_cuz_your_master_password_is_wrong
        end
      end
    end
  end
end
