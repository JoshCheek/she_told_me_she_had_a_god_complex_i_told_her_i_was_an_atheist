require 'surrogate/rspec'

module Interfaces
  class Interface
    Surrogate.endow self

    atheist = SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist

    define(:words_searched_for)           { ['search', 'words'] }
    define(:retrieve_encrypted_passwords) { atheist::Encrypt.call atheist::Passwords.new, _master_password }
    define(:master_password)              { _master_password }
    define(:name)                         { 'name' }
    define(:should_override_name?)        { true }
    define(:search_words)                 { |name| 'search words' }
    define(:password)                     { |name| 'password' }
    define(:persist_encrypted_passwords)  { |encrypted_file| }
    # rename success -> succeed
    define(:success)                      { |*args| }
    define(:old_master_password)          { 'old master password' }
    define(:new_master_password)          { 'new master password' }

    define(:fail_cuz_you_have_no_encrypted_passwords) { :fail_cuz_you_have_no_encrypted_passwords }
    define(:fail_cuz_your_master_password_is_wrong)   { :fail_cuz_your_master_password_is_wrong }
    define(:fail_cuz_invalid_name)                    { :fail_cuz_invalid_name }
    define(:fail_cuz_no_name_override)                { :fail_cuz_no_name_override }
    define(:fail_cuz_your_search_has_no_matches)      { :fail_cuz_your_search_has_no_matches }
    define(:fail_cuz_your_search_matched_multiples)   { |matched_passwords| :fail_cuz_your_search_matched_multiples }

    private

    def _master_password
      'master password'
    end
  end
end

