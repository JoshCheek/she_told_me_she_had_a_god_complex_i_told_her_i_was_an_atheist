require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/command_line_binary/user_interaction'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/command_line_binary/high_line_io'

module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class CommandLineBinary
    Callable.call self, :stdin, :stdout, :stderr, :argv, :env

    def call
      if argv == ['--set'] && File.exist?(password_filename)
        use_case(UseCases::ResetMasterPassword) { io.success "your master password has been set" }
      elsif argv == ['--set']
        use_case(UseCases::SetMasterPassword) { io.success "your master password has been set" }
      elsif argv == ['--add']
        use_case(UseCases::AddPassword) { |password| io.success "your password for '#{password.name}' is now being stored" } # uhm, use name.inspect once we fix haiti up a bit
      elsif argv == ['--list']
        use_case UseCases::ListPassword
      else
        use_case(UseCases::GetPassword) { |password|
          io.success "'#{password.name}' was copied to your clipboard"
          io.success "login: '#{password.login}'"
        } # uhm, use name.inspect once we fix haiti up a bit
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
      use_case.call UserInteraction.new(argv, io, password_filename, &message)
    end
  end
end
