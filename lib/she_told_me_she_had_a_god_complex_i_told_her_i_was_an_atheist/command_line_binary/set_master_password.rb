module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class CommandLineBinary
    class SetMasterPassword
      Callable.call self, :io, :password_filename

      def call
        master_password     = io.password 'enter your master password: '
        password_data       = Passwords.new
        encrypted_passwords = Encrypt.call password_data, master_password
        File.open(password_filename, 'w') { |f| f.write encrypted_passwords }
        io.success "your master password has been set"
        0
      end
    end
  end
end