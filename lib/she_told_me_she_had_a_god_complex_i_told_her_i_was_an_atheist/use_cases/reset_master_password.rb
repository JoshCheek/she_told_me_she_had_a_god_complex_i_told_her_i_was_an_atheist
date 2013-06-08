module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  module UseCases
    class ResetMasterPassword
      Callable.call self, :interface

      def call
        # this doesn't handle the case where there is no password file
        decrypted_passwords = Decrypt.call interface.retrieve_encrypted_passwords, interface.old_master_password
        if decrypted_passwords
          encrypted_passwords = Encrypt.call decrypted_passwords, interface.new_master_password
          interface.persist_encrypted_passwords encrypted_passwords
          interface.succeed
        else
          interface.fail_cuz_your_master_password_is_wrong
        end
      end
    end
  end
end
