require 'highline'

# move this into CLI namespace
# rename to HighLineIO
module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class CLI
    class HighLineIO
      def initialize(stdin, stdout, stderr)
        self.stdin  = HighLine.new stdin, stdout
        self.stdout = stdin()
        self.stderr = HighLine.new stdin, stderr
      end

      def password(prompt)
        stdin.ask(prompt) { |q| q.echo = false }
      end

      def boolean(prompt, defaults={})
        result = stdout.ask prompt
        return true  if defaults[:true]  && result.to_s =~ defaults[:true]
        return false if defaults[:false] && result.to_s =~ defaults[:false]
        defaults.fetch :default
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
end
