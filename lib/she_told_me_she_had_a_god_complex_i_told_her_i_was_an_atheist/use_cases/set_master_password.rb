require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/encrypt'
module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  module UseCases
    class SetMasterPassword
      Callable.call self, :interaction

      def call
        if interaction.master_password != interaction.master_password_confirmation
          return interaction.fail_cuz_your_master_password_confirmation_does_not_match
        end
        encrypted_passwords = Encrypt.call(Passwords.new, interaction.master_password)
        interaction.persist_encrypted_passwords encrypted_passwords
        interaction.succeed
      end
    end
  end
end
