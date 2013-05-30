module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class CommandLineBinary
    class SetMasterPassword
      Callable.call self, :io, :password_filename

      def call
        interface = Interface.new io, password_filename do
          io.success "your master password has been set"
        end
        SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist::SetMasterPassword.call interface
      end
    end
  end
end
