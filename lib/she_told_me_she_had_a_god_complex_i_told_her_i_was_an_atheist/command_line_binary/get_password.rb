module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class CommandLineBinary
    class GetPassword
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

        0
      end
    end
  end
end
