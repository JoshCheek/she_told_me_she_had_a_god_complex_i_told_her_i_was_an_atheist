require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/passwords'

module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  describe Passwords do
    let(:passwords) { described_class.new }

    describe '[]' do
      it 'returns the password associated to the given name' do
        passwords.add 'a', 'password' => 'pass', 'search_words' => 'search words'
        passwords['a'].name.should == 'a'
      end

      it 'returns nil if there is no password associated to the name' do
        passwords['a'].should be_nil
      end
    end

    describe '==' do
      it 'returns whether the passwords all match' do
        # empty
        empty_passwords = described_class.new
        empty_passwords.should == described_class.new

        # match
        passwords1a = described_class.new
        passwords1b = described_class.new
        passwords1a.add 'one', 'password' => 'pass', 'search_words' => 'search words'
        passwords1b.add 'one', 'password' => 'pass', 'search_words' => 'search words'
        passwords1a.should == passwords1b
        passwords1a.should_not == empty_passwords
        passwords1b.should_not == empty_passwords

        # different names
        passwords2 = described_class.new
        passwords2.add 'two', 'password' => 'pass', 'search_words' => 'search words'
        empty_passwords.should_not == passwords2
        passwords2.should_not == empty_passwords
        passwords2.should_not == passwords1a
        passwords1a.should_not == passwords2

        # different passes
        passwords3 = described_class.new
        passwords3.add 'one', 'password' => 'different pass', 'search_words' => 'search words'
        passwords3.should_not == passwords1a
        passwords1a.should_not == passwords3

        # different search words
        passwords4 = described_class.new
        passwords4.add 'one', 'password' => 'pass', 'search_words' => 'different search words'
        passwords4.should_not == passwords1a
        passwords1a.should_not == passwords4
      end
    end

    describe 'add' do
      it 'adds a password' do
        passwords['the name'].should be_nil
        passwords.add 'the name', 'password' => 'the password', 'search_words' => 'the search words'
        passwords['the name'].name.should == 'the name'
        passwords['the name'].password.should == 'the password'
        passwords['the name'].search_words.should == 'the search words'
      end
    end

    describe 'enumerables' do
      it 'implements enumerable' do
        passwords.add 'one', 'password' => 'pass1', 'search_words' => 'search words1'
        passwords.add 'two', 'password' => 'pass2', 'search_words' => 'search words2'
        passwords.map(&:name).should == %w[one two]
      end
    end
  end
end
