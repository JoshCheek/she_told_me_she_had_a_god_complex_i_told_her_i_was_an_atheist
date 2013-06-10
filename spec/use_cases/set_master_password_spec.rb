require 'spec_helper'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist'

module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  describe UseCases::SetMasterPassword do
    let(:master_pass) { 'MASTER PASS!' }
    let(:interaction) { Interfaces::UserInteraction.new }

    def call
      described_class.call interaction
    end

    before { interaction.will_have_master_password              master_pass }
    before { interaction.will_have_master_password_confirmation master_pass }

    specify 'when the master password cannot be confimed, it fails' do
      interaction.will_have_master_password_confirmation master_pass.reverse
      call
      interaction.was told_to :fail_cuz_your_master_password_confirmation_does_not_match
      interaction.was_not told_to :succeed
    end

    context 'when the master password is confirmed' do
      it 'encrypts a new password file with the master password and persists it' do
        call
        encrypted_passwords = Encrypt.call Passwords.new, master_pass
        interaction.was told_to(:persist_encrypted_passwords).with encrypted_passwords
      end

      it 'returns the succeed callback' do
        interaction.will_succeed :zomg
        call.should == :zomg
      end
    end
  end
end
