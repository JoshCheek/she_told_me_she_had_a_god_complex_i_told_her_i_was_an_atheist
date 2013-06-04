require 'pasteboard'

module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class GetPassword
    Callable.call self, :interface

    def call
      # encrypted passwords data must exist
      encrypted_passwords = interface.retrieve_encrypted_passwords
      return interface.fail_cuz_you_have_no_encrypted_passwords unless encrypted_passwords

      # master password must be correct
      master_password = interface.master_password
      passwords       = Decrypt.call encrypted_passwords, master_password
      return interface.fail_cuz_your_master_password_is_wrong unless passwords

      # 0 or 1 names must match
      matching_password_by_names = passwords.select do |pw|
        interface.words_searched_for.all? { |search_word| pw.name.include? search_word }
      end
      if matching_password_by_names.size > 1
        return interface.fail_cuz_your_search_matched_multiples matching_password_by_names
      end

      matching_password = matching_password_by_names.first || begin
        matching_password_by_search_words = passwords.select do |pw|
          interface.words_searched_for.all? { |search_word| pw.match? search_word }
        end
        if matching_password_by_search_words.size > 1
          return interface.fail_cuz_your_search_matched_multiples matching_password_by_search_words
        end
        matching_password_by_search_words.first
      end

      return interface.fail_cuz_your_search_has_no_matches unless matching_password

      Pasteboard.new.put [[Pasteboard::Type::UTF_8, matching_password.password]]

      interface.success matching_password
    end
  end
end
