require 'haiti'
Haiti.configure do |config|
  config.proving_grounds_dir = File.expand_path '../../../proving_grounds', __FILE__
  config.bin_dir             = File.expand_path '../../../bin',             __FILE__
end

password_filename = File.join Haiti.config.proving_grounds_dir, 'password_file'

ENV['she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist'] = password_filename

Before { File.delete password_filename if File.exist? password_filename }
