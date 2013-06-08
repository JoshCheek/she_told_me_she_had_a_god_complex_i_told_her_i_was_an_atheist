require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/command_line_binary/interface'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/command_line_binary/high_line_io'

module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class CommandLineBinary
    Callable.call self, :stdin, :stdout, :stderr, :argv, :env

    def call
      if argv == ['--set'] && File.exist?(password_filename)
        use_case(ResetMasterPassword) { io.success "your master password has been set" }
      elsif argv == ['--set']
        use_case(SetMasterPassword) { io.success "your master password has been set" }
      elsif argv == ['--add']
        use_case(AddPassword) { |password| io.success "your password for '#{password.name}' is now being stored" } # uhm, use name.inspect once we fix haiti up a bit
      elsif argv == ['--list']
        use_case ListPassword
      else
        use_case(GetPassword) { |password| io.success "'#{password.name}' was copied to your clipboard" } # uhm, use name.inspect once we fix haiti up a bit
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
      use_case.call Interface.new(argv, io, password_filename, &message)
    end
  end
end
