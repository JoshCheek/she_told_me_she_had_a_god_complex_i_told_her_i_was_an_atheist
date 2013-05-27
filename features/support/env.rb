require 'haiti'
Haiti.configure do |config|
  config.proving_grounds_dir = File.expand_path '../../../proving_grounds', __FILE__
  config.bin_dir             = File.expand_path '../../../bin',             __FILE__
end

require 'encryptor'
password_filename = File.join Haiti.config.proving_grounds_dir, 'password_file'

ENV['she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist'] = password_filename

Before { File.delete password_filename if File.exist? password_filename }


def master_password
  "THE MASTER PASSWORD"
end

Given 'a password file with' do |table|
  passwords = {}
  table.hashes.each do |hash|
    passwords[hash['name']] = {
      'password'     => hash['password'],
      'search_words' => hash['search words'],
    }
  end
  secret_key     = Digest::SHA256.hexdigest master_password
  encrypted_file = Encryptor.encrypt({'passwords' => passwords}.to_json, key: secret_key)
  File.open(password_filename, 'w') { |f| f.write encrypted_file }
end

Then 'my a password file contains' do |table|
  passwords = {}
  table.hashes.each do |hash|
    passwords[hash['name']] = {
      'password'     => hash['password'],
      'search_words' => hash['search words'],
    }
  end
  secret_key     = Digest::SHA256.hexdigest master_password
  encrypted_file = File.read password_filename
  password_data  = JSON.parse encrypted_file
  password_data['passwords'].should = passwords
end
