module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class ResetPassword
    Callable.call self, :io, :password_filename

    def call
      old_password        = io.password 'enter your old passord: '
      decrypted_passwords = Decrypt.call File.read(password_filename), old_password
      if decrypted_passwords
        new_password        = io.password 'enter your new passord: '
        encrypted_passwords = Encrypt.call decrypted_passwords, new_password
        File.open(password_filename, 'w') { |f| f.write encrypted_passwords }
        io.success "your master password has been set"
        0
      else
        io.failure "Incorrect master password"
        1
      end
    end
  end
end
