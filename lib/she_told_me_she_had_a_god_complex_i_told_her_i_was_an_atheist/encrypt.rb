module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class Encrypt
    def self.call(*args)
      new(*args).call
    end
    attr_accessor :unencrypted_passwords, :master_password
    def initialize(unencrypted_passwords, master_password)
      self.unencrypted_passwords = unencrypted_passwords
      self.master_password       = master_password
    end

    def call
      Encryptor.encrypt unencrypted_passwords,
        key: Digest::SHA256.hexdigest(master_password)
    end
  end
end
