require 'highline'

module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class HighlineIO
    def initialize
      self.highline = HighLine.new
    end

    def password(prompt)
      @password ||= highline.ask prompt
    end

    def success(message)
      highline.say highline.color(message, :green)
    end

    private

    attr_accessor :highline
  end
end
