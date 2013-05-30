require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/command_line_binary/interface'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/command_line_binary/get_password'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/command_line_binary/high_line_io'

module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class CommandLineBinary
    Callable.call self, :stdin, :stdout, :stderr, :argv, :env

    def call
      password_filename = env.fetch "she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist",
                                    "#{env['HOME']}/.she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist"
      if (argv == ['--set']) && File.exist?(password_filename)
        interface = Interface.new io, password_filename do
          io.success "your master password has been set"
        end
        SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist::ResetMasterPassword.call interface
      elsif argv == ['--set']
        interface = Interface.new io, password_filename do
          io.success "your master password has been set"
        end
        SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist::SetMasterPassword.call interface
      elsif argv == ['--add']
        interface = Interface.new io, password_filename do
          io.success "your password for '#{interface.get_name}' is now being stored"
        end
        SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist::AddPassword.call interface
      else
        GetPassword.call io, password_filename
      end
    end

    def io
      @io ||= HighLineIO.new stdin, stdout, stderr
    end
  end
end
