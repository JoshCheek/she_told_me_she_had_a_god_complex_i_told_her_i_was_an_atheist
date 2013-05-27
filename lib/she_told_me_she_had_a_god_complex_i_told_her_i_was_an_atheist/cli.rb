module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class CLI
    def initialize(io, argv, env)
      self.io   = io
      self.argv = argv
      self.env  = env
    end

    class Encryption
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
          Encryptor.decrypt encrypted_passwords, key: Digest::SHA256.hexdigest(master_password)
        rescue OpenSSL::OpenSSLError
        end
      end

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
          Encryptor.encrypt unencrypted_passwords, key: Digest::SHA256.hexdigest(master_password)
        end
      end
    end

    def call
      password_filename = env.fetch "she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist",
                                    "#{env['HOME']}/.she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist"
      if argv.include? '--set'
        if File.exist? password_filename
          old_password        = io.password 'enter your old passord: '
          decrypted_passwords = Encryption::Decrypt.call File.read(password_filename), old_password
          if decrypted_passwords
            new_password        = io.password 'enter your new passord: '
            encrypted_passwords = Encryption::Decrypt.call decrypted_passwords, new_password
            File.open(password_filename, 'w') { |f| f.write encrypted_passwords }
            io.success "your master password has been set"
            0
          else
            $stderr.puts "Incorrect master password" # should delegate to io.failure
            1
          end
        else
          password       = io.password 'enter your master password: '
          password_data  = { 'passwords' => {} }
          secret_key     = Digest::SHA256.hexdigest password
          encrypted_file = Encryptor.encrypt password_data.to_json, key: secret_key
          File.open(password_filename, 'w') { |f| f.write encrypted_file }
          io.success "your master password has been set"
          0
        end
      elsif argv.include? '--add'
        master_password = io.password 'enter your master password: '
        secret_key      = Digest::SHA256.hexdigest master_password
        encrypted_file  = File.read password_filename
        begin
          decrypted_file = Encryptor.decrypt encrypted_file, key: secret_key
          File.open(password_filename, 'w') { |f| f.write encrypted_file }
          io.success "your master password has been set"
        rescue OpenSSL::OpenSSLError
          $stderr.puts "Incorrect master password" # should delegate to io.failure
          exit 1
        end
      else
        raise "Don't know what to do with ARGV: #{ARGV.inspect}"
      end
    end

    private

    attr_accessor :io, :argv, :env
  end
end
