module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  module Callable
    def self.call(klass, *var_names)
      klass.__send__ :attr_accessor, *var_names

      def klass.call(*args)
        new(*args).call
      end

      klass.__send__ :define_method, :initialize do |*args|
        if args.size != var_names.size
          raise ArgumentError, "wrong number of arguments (#{args.size} for #{var_names.size})"
        end
        var_names.zip(args) { |name, value| send "#{name}=", value }
      end
    end
  end
end
