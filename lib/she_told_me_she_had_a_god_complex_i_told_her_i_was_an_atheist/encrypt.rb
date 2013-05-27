require 'json'
require 'encryptor'

module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class Encrypt
    Callable.call self, :unencrypted_passwords, :master_password

    def call
      Encryptor.encrypt json_passwords,
        key: Digest::SHA256.hexdigest(master_password)
    end

    private

    def json_passwords
      JSON.dump unencrypted_passwords
    end
  end
end
