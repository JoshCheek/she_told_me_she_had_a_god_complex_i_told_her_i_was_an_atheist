require 'json'
require 'encryptor'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/callable'

module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class Encrypt
    Callable.call self, :unencrypted_passwords, :master_password

    def call
      Encryptor.encrypt json_passwords,
        key: Digest::SHA256.hexdigest(master_password)
    end

    private

    def json_passwords
      JSON.dump unencrypted_passwords.to_primitive_data
    end
  end
end
