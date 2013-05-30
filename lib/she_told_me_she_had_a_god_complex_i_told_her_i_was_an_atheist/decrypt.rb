require 'json'
require 'encryptor'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/callable'

module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class Decrypt
    Callable.call self, :encrypted_passwords, :master_password

    def call
      Passwords.from_primitive_data JSON.load Encryptor.decrypt encrypted_passwords, key: Digest::SHA256.hexdigest(master_password.to_s)
    rescue OpenSSL::OpenSSLError
    end
  end
end
