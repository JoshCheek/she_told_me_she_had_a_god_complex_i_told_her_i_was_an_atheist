module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class CommandLineBinary
    class ResetMasterPassword
      Callable.call self, :io, :password_filename

      def call
        interface = Interface.new io, password_filename do
          io.success "your master password has been set"
        end
        SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist::ResetMasterPassword.call interface
      end
    end
  end
end
