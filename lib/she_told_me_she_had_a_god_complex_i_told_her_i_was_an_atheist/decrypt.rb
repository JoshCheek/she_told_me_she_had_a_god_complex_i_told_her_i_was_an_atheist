require 'json'
require 'encryptor'

module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class Decrypt
    Callable.call self, :encrypted_passwords, :master_password

    def call
      JSON.load Encryptor.decrypt encrypted_passwords,
        key: Digest::SHA256.hexdigest(master_password)
    rescue OpenSSL::OpenSSLError
    end
  end
end
