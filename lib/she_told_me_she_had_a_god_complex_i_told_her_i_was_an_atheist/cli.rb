module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class CLI
    def initialize(io, atheist)
      self.io = io
    end

    def call
      password = io.password 'enter your master password: '
      io.success "your master password has been set"
    end

    private

    attr_accessor :io
  end
end
