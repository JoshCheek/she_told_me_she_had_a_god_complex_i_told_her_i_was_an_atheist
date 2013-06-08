require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/passwords'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/encrypt'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/decrypt'

module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  describe 'encrypting and decrypting' do
    let(:passwords) { Passwords.new do |passwords|
                        passwords.add 'name1', 'login' => 'login1', 'password' => 'pass1', 'search_string' => 'search string1'
                        passwords.add 'name2', 'login' => 'login2', 'password' => 'pass2', 'search_string' => 'search string2'
                      end }

    specify 'encrypting a password makes it all giberishy' do
      encrypted = Encrypt.call passwords, 'master password'
      # looking at http://www.asciitable.com/, space seems to be the smallest printable char, and ~ seems to be the largest
      non_readable_chars = encrypted.each_char.select { |char|
        char.ord < ' '.ord || char.ord > '~'.ord
      }
      non_readable_chars.should_not be_empty
    end

    specify 'encrypting a passwords collection does not mutate it' do
      Encrypt.call passwords, 'master password'
      passwords.map(&:name).should =~ %w[name1 name2]
      passwords.map(&:login).should =~ %w[login1 login2]
      passwords.map(&:password).should =~ %w[pass1 pass2]
      passwords.map(&:search_string).should =~ ['search string1', 'search string2']
    end

    specify 'decrypting a passwords collection returns the same collection that was encrypted' do
      encrypted = Encrypt.call passwords, 'master password'
      decrypted = Decrypt.call encrypted, 'master password'
      decrypted.map(&:name).should =~ %w[name1 name2]
      decrypted.map(&:password).should =~ %w[pass1 pass2]
      decrypted.map(&:search_string).should =~ ['search string1', 'search string2']
    end
  end
end
