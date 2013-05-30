require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/command_line_binary/interface'

module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class CommandLineBinary
    class AddPassword
      Callable.call self, :io, :password_filename

      def call
        interface = Interface.new io, password_filename do
          io.success "your password for '#{interface.get_name}' is now being stored"
        end
        SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist::AddPassword.call interface
      end
    end
  end
end
