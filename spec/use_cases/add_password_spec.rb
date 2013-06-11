require 'spec_helper'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist'

describe SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist::UseCases::AddPassword do
  let(:master_pass)  { 'MASTER PASS!' }
  let(:atheist)      { SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist }
  let(:interaction)  { Interfaces::UserInteraction.new }

  def password_data(name, search_string)
    [name, {'password' => 'irrelevant', 'login' => 'login', 'search_string' => search_string}]
  end

  def has_passwords(*password_datas)
    passwords = atheist::Passwords.new
    password_datas.each { |data| passwords.add *data }
    interaction.will_retrieve_encrypted_passwords atheist::Encrypt.call passwords, master_pass
    interaction.will_have_master_password master_pass
    passwords
  end

  def call
    described_class.call interaction
  end

  before { has_passwords }

  it 'requires encrypted passwords' do
    interaction.will_retrieve_encrypted_passwords nil
    call.should == :fail_cuz_you_have_no_encrypted_passwords
    interaction.was_not asked_for :master_password
  end

  it 'requires a correct master password' do
    interaction.will_have_master_password 'not the master password'
    call.should == :fail_cuz_your_master_password_is_wrong
    interaction.was_not asked_for :name
  end

  it 'requires a non-empty name' do
    interaction.will_have_name ''
    call.should == :fail_cuz_invalid_name
    interaction.was_not asked_for :login
  end

  it 'requires a confirmation if the password being added already exists' do
    has_passwords password_data('gmail.com', 'mail google')
    interaction.will_have_name 'gmail.com'
    interaction.will_should_override_name? false # isn't there a way to do this better? it seems undocumented
    call.should == :fail_cuz_no_name_override
    interaction.was asked_if :should_override_name? # not necessary, but if it fails, will be a much more helpful error
    interaction.was_not asked_for :login
  end

  it 'adds the password to the password list' do
    interaction.will_have_name 'gmail.com'
    interaction.will_have_login 'josh.cheek@gmail.com'
    interaction.will_have_search_string 'mail google'
    interaction.will_have_password 'super secret pass'
    interaction.will_should_override_name? false # shows that this will not be invoked, b/c there is no conflict
    call
    interaction.was told_to :succeed
    encrypted_passwords = interaction.instance_variable_get('@hatchling').invocations(:persist_encrypted_passwords).first.args.first # blech
    decrypted_passwords = atheist::Decrypt.call encrypted_passwords, master_pass
    decrypted_passwords['gmail.com'].tap do |pass|
      pass.name.should == 'gmail.com'
      pass.login.should == 'josh.cheek@gmail.com'
      pass.search_string.should == 'mail google'
      pass.password.should == 'super secret pass'
    end
  end

  it 'overrides existing passwords when confirmed' do
    has_passwords password_data('gmail.com', 'some old search string')
    interaction.will_have_name 'gmail.com'
    interaction.will_have_search_string 'some new search string'
    interaction.will_should_override_name? true # isn't there a way to do this better? it seems undocumented
    call
    interaction.was told_to :succeed
    encrypted_passwords = interaction.instance_variable_get('@hatchling').invocations(:persist_encrypted_passwords).first.args.first # blech
    atheist::Decrypt.call(encrypted_passwords, master_pass)['gmail.com'].search_string.should == 'some new search string'
  end
end
