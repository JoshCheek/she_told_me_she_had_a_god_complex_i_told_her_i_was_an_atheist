require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/cli/set_master_password'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/cli/reset_master_password'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/cli/add_password'

module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class CLI
    Callable.call self, :io, :argv, :env

    def call
      password_filename = env.fetch "she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist",
                                    "#{env['HOME']}/.she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist"
      if argv.include? '--set'
        # try refactoring to this later
        # action = SetMasterPassword
        # action = ResetMasterPassword if File.exist? password_filename
        # action.call io, password_filename
        if File.exist? password_filename
          ResetMasterPassword.call io, password_filename
        else
          SetMasterPassword.call io, password_filename
        end
      elsif argv.include? '--add'
        AddPassword.call io, password_filename
      else
        raise "Don't know what to do with ARGV: #{ARGV.inspect}"
      end
    end
  end
end
