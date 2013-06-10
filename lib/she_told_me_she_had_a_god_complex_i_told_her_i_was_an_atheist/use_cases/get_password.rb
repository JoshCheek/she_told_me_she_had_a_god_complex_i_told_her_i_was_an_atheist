require 'pasteboard'

module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  module UseCases
    class GetPassword
      Callable.call self, :interaction

      def call
        # encrypted passwords data must exist
        encrypted_passwords = interaction.retrieve_encrypted_passwords
        return interaction.fail_cuz_you_have_no_encrypted_passwords unless encrypted_passwords

        # master password must be correct
        master_password = interaction.master_password
        passwords       = Decrypt.call encrypted_passwords, master_password
        return interaction.fail_cuz_your_master_password_is_wrong unless passwords

        # 0 or 1 names must match
        matching_password_by_names = passwords.select do |pw|
          interaction.words_searched_for.all? { |search_word| pw.name.include? search_word }
        end
        if matching_password_by_names.size > 1
          return interaction.fail_cuz_your_search_matched_multiples matching_password_by_names
        end

        # if no matching name, must have exactly 1 that matches search string or name
        matching_password = matching_password_by_names.first || begin
          matching_password_by_search_string = passwords.select do |pw|
            interaction.words_searched_for.all? { |search_word| pw.match? search_word }
          end
          if matching_password_by_search_string.size > 1
            return interaction.fail_cuz_your_search_matched_multiples matching_password_by_search_string
          end
          matching_password_by_search_string.first
        end

        # must have found a match
        return interaction.fail_cuz_your_search_has_no_matches unless matching_password

        # copy to clipboard
        Pasteboard.new.put [[Pasteboard::Type::UTF_8, matching_password.password]]

        # hooray, we did it!
        interaction.succeed matching_password
      end
    end
  end
end
