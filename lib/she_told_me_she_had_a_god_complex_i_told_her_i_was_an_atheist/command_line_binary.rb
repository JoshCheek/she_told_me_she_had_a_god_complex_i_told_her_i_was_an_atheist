require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/command_line_binary/interface'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/command_line_binary/get_password'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/command_line_binary/high_line_io'

module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class CommandLineBinary
    Callable.call self, :stdin, :stdout, :stderr, :argv, :env

    def call
      if argv == ['--set'] && File.exist?(password_filename)
        use_case(ResetMasterPassword) { "your master password has been set" }
      elsif argv == ['--set']
        use_case(SetMasterPassword) { "your master password has been set" }
      elsif argv == ['--add']
        use_case(AddPassword) { |interface| "your password for '#{interface.name}' is now being stored" }
      else
        GetPassword.call io, password_filename
      end
    end

    def io
      @io ||= HighLineIO.new stdin, stdout, stderr
    end

    def password_filename
      @password_filename ||= env.fetch "she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist",
                                       "#{env['HOME']}/.she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist"
    end

    def use_case(use_case, &message)
      interface = Interface.new(io, password_filename) { io.success message.call interface }
      use_case.call interface
    end
  end
end
