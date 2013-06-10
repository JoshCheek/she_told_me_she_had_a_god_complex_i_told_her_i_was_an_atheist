require 'spec_helper'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist'

describe SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist::UseCases::GetPassword do

  # perhaps these should be some rspec-wide helpers?
  let(:master_pass) { 'MASTER PASS!' }

  def has_passwords(*password_datas)
    passwords = atheist::Passwords.new
    password_datas.each { |data| passwords.add *data }
    interaction.will_retrieve_encrypted_passwords atheist::Encrypt.call passwords, master_pass
    interaction.will_have_master_password master_pass
    passwords
  end

  def password_data(name, search_string)
    [name, {'password' => 'irrelevant', 'login' => 'login', 'search_string' => search_string}]
  end

  let(:atheist)     { SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist }
  let(:interaction) { Interfaces::UserInteraction.new }

  def call
    described_class.call interaction
  end

  it 'returns appropriate failure status when unable to retrieve the encrypted passwords' do
    interaction.will_retrieve_encrypted_passwords false
    call.should == :fail_cuz_you_have_no_encrypted_passwords
    interaction.was_not asked_for :master_password
  end

  it 'fails unless the master password matches' do
    master_pass = 'MASTER PASS!'
    interaction.will_retrieve_encrypted_passwords atheist::Encrypt.call atheist::Passwords.new, master_pass
    interaction.will_have_master_password master_pass.reverse
    call.should == :fail_cuz_your_master_password_is_wrong
    # surrogate: maybe also told_about, e.g. `.was_not told_about :success`
    interaction.was_not told_to :succeed
  end

  describe 'finding the password to get' do
    it 'finds the password if there is only one name that matches' do
      passwords = has_passwords password_data('pass match', 'search1'), password_data('pass2', 'search2')
      interaction.will_have_words_searched_for ['pass', 'match']
      call
      interaction.was told_to(:succeed).with passwords['pass match']
    end

    # alias told_to told_about

    it 'finds the password if there is no matching name and only one search term that matches' do
      passwords = has_passwords password_data('pass1', 'match1'), password_data('pass2', 'search2')
      interaction.will_have_words_searched_for ['match', '1']
      call
      interaction.was told_to(:succeed).with passwords['pass1']
    end

    it 'finds the matching name even if there are others with matching search terms' do
      passwords = has_passwords password_data('pass1', 'match1'), password_data('match2', 'search2'), password_data('pass3', 'match3')
      interaction.will_have_words_searched_for ['match']
      call
      interaction.was told_to(:succeed).with passwords['match2']
    end

    it 'finds the matching name/search terms' do
      passwords = has_passwords password_data('pass1', 'search1'), password_data('pass2', 'match2')
      interaction.will_have_words_searched_for ['pass', 'match']
      call
      interaction.was told_to(:succeed).with passwords['pass2']
    end

    it 'fails if there are multiple matching names' do
      passwords = has_passwords password_data('match1', 'search1'), password_data('match2', 'search2'), password_data('pass3', 'search3')
      interaction.will_have_words_searched_for ['match']
      call.should == :fail_cuz_your_search_matched_multiples
      interaction.was told_to(:fail_cuz_your_search_matched_multiples).with([passwords['match1'], passwords['match2']])
    end

    it 'fails if there are no matching names, and multiple matching search terms' do
      passwords = has_passwords password_data('pass1', 'match1'), password_data('pass2', 'match2'), password_data('pass3', 'search3')
      interaction.will_have_words_searched_for ['match']
      call.should == :fail_cuz_your_search_matched_multiples
      interaction.was told_to(:fail_cuz_your_search_matched_multiples).with([passwords['pass1'], passwords['pass2']])
    end

    it 'fails if there are neither matching names, nor matching search terms' do
      has_passwords password_data('pass1', 'search1'), password_data('pass2', 'search2'), password_data('pass3', 'search3')
      interaction.will_have_words_searched_for ['match']
      call.should == :fail_cuz_your_search_has_no_matches
      interaction.was told_to(:fail_cuz_your_search_has_no_matches)
    end
  end

  it 'returns the succeed result when it succeeds' do
    has_passwords password_data('match', 'match')
    interaction.will_have_words_searched_for ['match']
    call
    interaction.was told_to(:succeed)
  end
end
