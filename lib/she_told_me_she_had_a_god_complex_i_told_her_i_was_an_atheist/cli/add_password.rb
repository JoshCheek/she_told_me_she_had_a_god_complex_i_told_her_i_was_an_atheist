module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  # these should be in the CLI namespace
  class AddPassword
    Callable.call self, :io, :password_filename

    # need to handle the case where there is not an existing password file
    def call
      master_password = io.password 'enter your master password: '
      passwords = Decrypt.call File.read(password_filename), master_password
      if passwords
        name         = io.ask "what is this a password for? "
        search_words = io.ask "enter search words: "
        password     = io.password "enter the password for #{name}: "

        # what do we want to do if this is a duplicate?
        passwords['passwords'][name] = {'password' => password, 'search_words' => search_words}
        encrypted_file = Encrypt.call passwords, master_password
        File.open(password_filename, 'w') { |f| f.write encrypted_file }

        # name should be inspected here, but have to fix Haiti up a bit first
        io.success "your password for '#{name}' is now being stored"
        0
      else
        io.failure "incorrect master password"
        1
      end
    end
  end
end
