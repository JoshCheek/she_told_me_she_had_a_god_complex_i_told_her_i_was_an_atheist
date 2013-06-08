require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/passwords'

module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  describe Passwords do
    let(:passwords) { described_class.new }

    describe '[]' do
      it 'returns the password associated to the given name' do
        passwords.add 'a', 'password' => 'pass', 'login' => 'login', 'search_string' => 'search string'
        passwords['a'].name.should == 'a'
      end

      it 'returns nil if there is no password associated to the name' do
        passwords['a'].should be_nil
      end
    end

    describe '==' do
      # can we make this pass by removing
      it 'returns whether the passwords all match' do
        # empty
        empty_passwords = described_class.new
        empty_passwords.should == described_class.new

        # match
        passwords1a = described_class.new
        passwords1b = described_class.new
        passwords1a.add 'one', 'password' => 'pass', 'login' => 'login', 'search_string' => 'search string'
        passwords1b.add 'one', 'password' => 'pass', 'login' => 'login', 'search_string' => 'search string'
        passwords1a.should == passwords1b
        passwords1a.should_not == empty_passwords
        passwords1b.should_not == empty_passwords

        # different names
        passwords2 = described_class.new
        passwords2.add 'two', 'password' => 'pass', 'login' => 'login', 'search_string' => 'search string'
        empty_passwords.should_not == passwords2
        passwords2.should_not == empty_passwords
        passwords2.should_not == passwords1a
        passwords1a.should_not == passwords2

        # different passes
        passwords3 = described_class.new
        passwords3.add 'one', 'password' => 'different pass', 'login' => 'login', 'search_string' => 'search string'
        passwords3.should_not == passwords1a
        passwords1a.should_not == passwords3

        # different search string
        passwords4 = described_class.new
        passwords4.add 'one', 'password' => 'pass', 'login' => 'login', 'search_string' => 'different search string'
        passwords4.should_not == passwords1a
        passwords1a.should_not == passwords4
      end
    end

    describe 'add' do
      it 'adds a password' do
        passwords['the name'].should be_nil
        passwords.add 'the name', 'password' => 'the password', 'login' => 'the_login', 'search_string' => 'the search string'
        passwords['the name'].name.should == 'the name'
        passwords['the name'].login.should == 'the_login'
        passwords['the name'].password.should == 'the password'
        passwords['the name'].search_string.should == 'the search string'
      end

      it 'returns the added password' do
        password = passwords.add 'the name', 'password' => 'the password', 'login' => 'login', 'search_string' => 'the search string'
        password.should == passwords['the name']
      end
    end

    describe 'enumerables' do
      it 'implements enumerable' do
        passwords.add 'one', 'password' => 'pass1', 'login' => 'login', 'search_string' => 'search string1'
        passwords.add 'two', 'password' => 'pass2', 'login' => 'login', 'search_string' => 'search string2'
        passwords.map(&:name).should == %w[one two]
      end
    end
  end

  describe Passwords::Password do
    describe 'match?' do
      def will_match(name, search_string, query)
        described_class.new(name, 'login', 'password', search_string).should be_match query
      end

      def will_not_match(name, search_string, query)
        described_class.new(name, 'login', 'password', search_string).should_not be_match query
      end

      it 'returns true if the word is a substring of its search_string or name' do
        # search string
        will_match '', 'abc def', 'abc'
        will_match '', 'abc def', 'def'
        will_match '', 'abc def', 'a'
        will_match '', 'abc def', 'b'
        will_match '', 'abc def', 'd'
        will_match '', 'abc def', 'abc def'
        will_not_match '', 'abc def', 'A'
        will_not_match '', 'abc def', 'g'

        # name
        will_match 'abc def', '', 'abc'
        will_not_match 'abc def', '', 'Abc'
        will_not_match 'abc def', '', 'x'
      end
    end
  end
end
