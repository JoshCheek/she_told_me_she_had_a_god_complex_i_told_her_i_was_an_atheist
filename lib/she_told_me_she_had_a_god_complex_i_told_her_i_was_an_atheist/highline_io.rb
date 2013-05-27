require 'highline'

module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class HighlineIO
    def initialize
      self.highline = HighLine.new
    end

    def password(prompt)
      highline.ask(prompt) { |q| q.echo = false }
    end

    def success(message)
      highline.say highline.color(message, :green)
    end

    private

    attr_accessor :highline
  end
end
