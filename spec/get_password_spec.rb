require 'spec_helper'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist'

# TODO: rename "search_terms" to "search_string" internally

describe SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist::GetPassword do

  # perhaps these should be some rspec-wide helpers?
  let(:master_pass) { 'MASTER PASS!' }

  def has_passwords(*password_datas)
    passwords = atheist::Passwords.new
    password_datas.each { |data| passwords.add *data }
    interface.will_retrieve_encrypted_passwords atheist::Encrypt.call passwords, master_pass
    interface.will_have_master_password master_pass
    passwords
  end

  def password_data(name, search_words)
    [name, {'password' => 'irrelevant', 'search_words' => search_words}]
  end


  # move me somewhere bettah, and give it a bettah name
  specify 'interfaces match' do
    require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/command_line_binary/interface'
    SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist::CommandLineBinary::Interface.should \
      substitute_for Interfaces::Interface, subset: true, names: true
  end

  let(:atheist)   { SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist }
  let(:interface) { Interfaces::Interface.new }

  def call
    described_class.call interface
  end

  it 'returns appropriate failure status when unable to retrieve the encrypted passwords' do
    interface.will_retrieve_encrypted_passwords false
    call.should == :fail_cuz_you_have_no_encrypted_passwords
    interface.was_not asked_for :master_password
  end

  it 'fails unless the master password matches' do
    master_pass = 'MASTER PASS!'
    interface.will_retrieve_encrypted_passwords atheist::Encrypt.call atheist::Passwords.new, master_pass
    interface.will_have_master_password master_pass.reverse
    call.should == :fail_cuz_your_master_password_is_wrong
    # surrogate: maybe also told_about, e.g. `.was_not told_about :success`
    interface.was_not told_to :success
  end

  describe 'finding the password to get' do
    it 'finds the password if there is only one name that matches' do
      passwords = has_passwords password_data('pass match', 'search1'), password_data('pass2', 'search2')
      interface.will_have_words_searched_for ['pass', 'match']
      call
      interface.was told_to(:success).with passwords['pass match']
    end

    # alias told_to told_about

    it 'finds the password if there is no matching name and only one search term that matches' do
      passwords = has_passwords password_data('pass1', 'match1'), password_data('pass2', 'search2')
      interface.will_have_words_searched_for ['match', '1']
      call
      interface.was told_to(:success).with passwords['pass1']
    end

    it 'finds the matching name even if there are others with matching search terms' do
      passwords = has_passwords password_data('pass1', 'match1'), password_data('match2', 'search2'), password_data('pass3', 'match3')
      interface.will_have_words_searched_for ['match']
      call
      interface.was told_to(:success).with passwords['match2']
    end

    it 'finds the matching name/search terms' do
      passwords = has_passwords password_data('pass1', 'search1'), password_data('pass2', 'match2')
      interface.will_have_words_searched_for ['pass', 'match']
      call
      interface.was told_to(:success).with passwords['pass2']
    end

    it 'fails if there are multiple matching names' do
      passwords = has_passwords password_data('match1', 'search1'), password_data('match2', 'search2'), password_data('pass3', 'search3')
      interface.will_have_words_searched_for ['match']
      call.should == :fail_cuz_your_search_matched_multiples
      interface.was told_to(:fail_cuz_your_search_matched_multiples).with([passwords['match1'], passwords['match2']])
    end

    it 'fails if there are no matching names, and multiple matching search terms' do
      passwords = has_passwords password_data('pass1', 'match1'), password_data('pass2', 'match2'), password_data('pass3', 'search3')
      interface.will_have_words_searched_for ['match']
      call.should == :fail_cuz_your_search_matched_multiples
      interface.was told_to(:fail_cuz_your_search_matched_multiples).with([passwords['pass1'], passwords['pass2']])
    end

    it 'fails if there are neither matching names, nor matching search terms' do
      has_passwords password_data('pass1', 'search1'), password_data('pass2', 'search2'), password_data('pass3', 'search3')
      interface.will_have_words_searched_for ['match']
      call.should == :fail_cuz_your_search_has_no_matches
      interface.was told_to(:fail_cuz_your_search_has_no_matches)
    end
  end

  it 'returns the success result when it succeeds' do
    has_passwords password_data('match', 'match')
    interface.will_have_words_searched_for ['match']
    call
    interface.was told_to(:success)
  end
end
