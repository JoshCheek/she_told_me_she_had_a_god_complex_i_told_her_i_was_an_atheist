module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class CommandLineBinary
    class AddPassword
      Callable.call self, :io, :password_filename

      def call

        # password file must exist
        if !File.exist?(password_filename)
          io.failure "there is no password file at #{password_filename.inspect}, to create it, set the master password"
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

        # user must confirm override if name already exists
        if passwords[name]
          confirmed = io.boolean "#{name.inspect} is already being stored, override it? (y/N)",
            true: /^y/i,
            false: /^n/i,
            default: false
          return 0 unless confirmed
        end

        search_words = io.ask "enter search words: "
        password     = io.password "enter the password for #{name}: "

        passwords.add name, 'password' => password, 'search_words' => search_words
        encrypted_file = Encrypt.call passwords, master_password
        File.open(password_filename, 'w') { |f| f.write encrypted_file }

        # name should be inspected here, but have to fix Haiti up a bit first
        io.success "your password for '#{name}' is now being stored"
        0
      end
    end
  end
end