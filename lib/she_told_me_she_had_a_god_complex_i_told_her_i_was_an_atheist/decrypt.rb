require 'json'
require 'encryptor'

module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class Decrypt
    def self.call(*args)
      new(*args).call
    end
    attr_accessor :encrypted_passwords, :master_password
    def initialize(encrypted_passwords, master_password)
      self.encrypted_passwords = encrypted_passwords
      self.master_password     = master_password
    end

    def call
      JSON.load Encryptor.decrypt encrypted_passwords,
        key: Digest::SHA256.hexdigest(master_password)
    rescue OpenSSL::OpenSSLError
    end
  end
end
