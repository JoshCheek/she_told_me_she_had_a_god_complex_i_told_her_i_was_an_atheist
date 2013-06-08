module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  module UseCases
    class SetMasterPassword
      Callable.call self, :interface

      def call
        encrypted_passwords = Encrypt.call(Passwords.new, interface.master_password)
        interface.persist_encrypted_passwords encrypted_passwords
        interface.succeed
      end
    end
  end
end
