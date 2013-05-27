require 'highline'

# move this into CLI namespace
module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class HighlineIO
    def initialize(stdin, stdout, stderr)
      self.stdin  = HighLine.new stdin, stdout
      self.stdout = stdin()
      self.stderr = HighLine.new stdin, stderr
    end

    def password(prompt)
      stdin.ask(prompt) { |q| q.echo = false }
    end

    def ask(prompt)
      stdin.ask prompt
    end

    def success(message)
      stdout.say stdout.color(message, :green)
    end

    def failure(message)
      stderr.say stderr.color(message, :red)
    end

    private

    attr_accessor :stdin, :stdout, :stderr
  end
end
