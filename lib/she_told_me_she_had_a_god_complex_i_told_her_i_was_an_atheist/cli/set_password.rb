module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class SetPassword
    attr_accessor :io, :password_filename

    def self.call(io, password_filename)
      new(io, password_filename).call
    end

    def initialize(io, password_filename)
      self.io                = io
      self.password_filename = password_filename
    end

    def call
      master_password     = io.password 'enter your master password: '
      password_data       = { 'passwords' => {} } # eventually make this a class
      encrypted_passwords = Encrypt.call password_data, master_password
      File.open(password_filename, 'w') { |f| f.write encrypted_passwords }
      io.success "your master password has been set"
      0
    end
  end
end
