module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class GetPassword
    Callable.call self, :interface

    def call
      # encrypted passwords data must exist
      encrypted_passwords = interface.retrieve_encrypted_passwords
      return interface.fail_cuz_you_have_no_encrypted_passwords unless encrypted_passwords

      # master password must be correct
      master_password = interface.master_password
      passwords       = Decrypt.call encrypted_passwords, master_password
      return interface.fail_cuz_your_master_password_is_wrong unless passwords

      interface.success
    end
  end
end
