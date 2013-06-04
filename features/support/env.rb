$LOAD_PATH.unshift '../../../lib', __FILE__
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/passwords'

# load/configure haiti
require 'haiti'
Haiti.configure do |config|
  config.proving_grounds_dir = File.expand_path '../../../proving_grounds', __FILE__
  config.bin_dir             = File.expand_path '../../../bin',             __FILE__
end

# set env var so lib doesn't overwrite global data or w/e
def password_filename
  File.join Haiti.config.proving_grounds_dir, 'password_file'
end
ENV['she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist'] = password_filename

# delete the password file if it exists, so each test starts clean
Before { File.delete password_filename if File.exist? password_filename }
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist'

# choose some master password to be used in cukes that don't care what its value is
def master_password
  "THE MASTER PASSWORD"
end




# some step defs that should eventually be moved out

Given 'I delete my password file' do
  File.delete password_filename if File.exist? password_filename
end

Then 'there is no password file' do
  File.exist?(password_filename).should be_false
end

Given 'a password file with' do |table|
  passwords = SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist::Passwords.new do |p|
    table.hashes.each do |hash|
      p.add hash['name'], 'password' => hash['password'], 'search_string' => hash['search words']
    end
  end
  encrypted = SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist::Encrypt.call passwords, master_password
  File.open(password_filename, 'w') { |f| f.write encrypted }
end

Then 'my a password file contains' do |table|
  expected_passwords = SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist::Passwords.new do |p|
    table.hashes.each do |hash|
      p.add hash['name'], 'password' => hash['password'], 'search_string' => hash['search words']
    end
  end
  actual_passwords = SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist::Decrypt.call File.read(password_filename), master_password
  actual_passwords.should == expected_passwords
end

And '"$text" was copied to my clipboard' do |text|
  pb = Pasteboard.new
  pb.sync
  pb.get_item_count.should == 1
  pb.first(Pasteboard::Type::UTF_8).should == text
end
