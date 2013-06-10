module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  module UseCases
    class ResetMasterPassword
      Callable.call self, :interaction

      def call
        encrypted_passwords = interaction.retrieve_encrypted_passwords
        unless encrypted_passwords
          return interaction.fail_cuz_you_have_no_encrypted_passwords
        end

        decrypted_passwords = Decrypt.call encrypted_passwords, interaction.old_master_password
        unless decrypted_passwords
          return interaction.fail_cuz_your_master_password_is_wrong
        end

        new_master_password = interaction.new_master_password
        new_master_password_confirmation = interaction.new_master_password_confirmation
        unless new_master_password == new_master_password_confirmation
          return interaction.fail_cuz_your_new_master_password_confirmation_does_not_match
        end

        re_encrypted_passwords = Encrypt.call decrypted_passwords, new_master_password
        interaction.persist_encrypted_passwords re_encrypted_passwords
        interaction.succeed
      end
    end
  end
end
