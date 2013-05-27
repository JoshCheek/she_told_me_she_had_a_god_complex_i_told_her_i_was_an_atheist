require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/encrypt'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/decrypt'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/cli/set_password'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/cli/reset_password'

module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class CLI
    Callable.call self, :io, :argv, :env

    def call
      password_filename = env.fetch "she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist",
                                    "#{env['HOME']}/.she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist"
      if argv.include? '--set'
        if File.exist? password_filename
          ResetPassword.call io, password_filename
        else
          SetPassword.call io, password_filename
        end
      elsif argv.include? '--add'
        # master_password = io.password 'enter your master password: '
        # secret_key      = Digest::SHA256.hexdigest master_password
        # encrypted_file  = File.read password_filename
        # begin
        #   decrypted_file = Encryptor.decrypt encrypted_file, key: secret_key
        #   File.open(password_filename, 'w') { |f| f.write encrypted_file }
        #   io.success "your master password has been set"
        # rescue OpenSSL::OpenSSLError
        #   $stderr.puts "Incorrect master password" # should delegate to io.failure
        #   exit 1
        # end
      else
        raise "Don't know what to do with ARGV: #{ARGV.inspect}"
      end
    end
  end
end
