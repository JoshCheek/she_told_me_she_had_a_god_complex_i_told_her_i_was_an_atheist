module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  # these should be in the CLI namespace
  class AddPassword
    Callable.call self, :io, :password_filename

    # need to handle the case where there is not an existing password file
    def call

      # password file must exist
      if !File.exist?(password_filename)
        io.failure "there is no password file at #{password_filename.inspect}, first set the master password"
        return 1
      end

      # master password must be correct
      master_password = io.password 'enter your master password: '
      passwords = Decrypt.call File.read(password_filename), master_password
      if !passwords
        io.failure "incorrect master password"
        return 1
      end

      # name must be valid
      name = io.ask "what is this a password for? "
      if name.to_s.empty?
        io.failure "invalid name"
        return 1
      end

      search_words = io.ask "enter search words: "
      password     = io.password "enter the password for #{name}: "

      # what do we want to do if this is a duplicate?
      passwords['passwords'][name] = {'password' => password, 'search_words' => search_words}
      encrypted_file = Encrypt.call passwords, master_password
      File.open(password_filename, 'w') { |f| f.write encrypted_file }

      # name should be inspected here, but have to fix Haiti up a bit first
      io.success "your password for '#{name}' is now being stored"
      0
    end
  end
end
