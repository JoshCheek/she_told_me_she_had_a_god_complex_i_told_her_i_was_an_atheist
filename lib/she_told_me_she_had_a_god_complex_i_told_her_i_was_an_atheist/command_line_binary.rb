require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/command_line_binary/set_master_password'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/command_line_binary/reset_master_password'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/command_line_binary/add_password'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/command_line_binary/get_password'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/command_line_binary/high_line_io'

module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class CommandLineBinary
    Callable.call self, :stdin, :stdout, :stderr, :argv, :env

    def call
      password_filename = env.fetch "she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist",
                                    "#{env['HOME']}/.she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist"
      if argv == ['--set']
        action = SetMasterPassword
        action = ResetMasterPassword if File.exist? password_filename
        action.call io, password_filename
      elsif argv == ['--add']
        AddPassword.call io, password_filename
      else
        GetPassword.call io, password_filename
      end
    end

    def io
      @io ||= HighLineIO.new stdin, stdout, stderr
    end
  end
end
