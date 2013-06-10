module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  module UseCases
    class SetMasterPassword
      Callable.call self, :interaction

      def call
        encrypted_passwords = Encrypt.call(Passwords.new, interaction.master_password)
        interaction.persist_encrypted_passwords encrypted_passwords
        interaction.succeed
      end
    end
  end
end
