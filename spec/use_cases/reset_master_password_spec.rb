require 'spec_helper'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist'

module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  describe UseCases::ResetMasterPassword, t:true do
    let(:old_master_pass) { 'OLD MASTER PASS!' }
    let(:new_master_pass) { 'NEW MASTER PASS!' }
    let(:interaction) { Interfaces::UserInteraction.new }

    def call
      described_class.call interaction
    end

    before { interaction.will_have_old_master_password old_master_pass }
    before { interaction.will_have_new_master_password new_master_pass }
    before { interaction.will_have_new_master_password_confirmation new_master_pass }

    it 'fails if there is not currently a master password set' do
      interaction.will_retrieve_encrypted_passwords nil
      call.should == :fail_cuz_you_have_no_encrypted_passwords
      interaction.was_not told_to :succeed
    end

    it 'fails if the old master password is incorrect' do
      interaction.will_retrieve_encrypted_passwords 'some bullshit'
      interaction.will_fail_cuz_your_master_password_is_wrong :zomg
      call.should == :zomg
      interaction.was_not told_to :succeed
    end

    it 're-encrypts the passwords using the new password' do
      passwords = Passwords.new { |p| p.add 'a', 'password' => 'pass1', 'login' => 'login', 'search_string' => 'search string1' }
      interaction.will_retrieve_encrypted_passwords Encrypt.call(passwords, old_master_pass)
      interaction.will_succeed :hooray
      call.should == :hooray
      interaction.was told_to(:persist_encrypted_passwords).with(Encrypt.call passwords, new_master_pass)
      interaction.was_not told_to :fail_cuz_your_master_password_is_wrong
    end

    it 'fails if the new master password fails confirmation' do
      interaction.will_retrieve_encrypted_passwords Encrypt.call(Passwords.new, old_master_pass)
      interaction.will_have_new_master_password_confirmation new_master_pass.reverse
      call.should == :fail_cuz_your_new_master_password_confirmation_does_not_match
      interaction.was_not told_to :succeed
    end
  end
end

