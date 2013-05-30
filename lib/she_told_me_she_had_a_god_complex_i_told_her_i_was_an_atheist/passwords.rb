module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class Passwords
    Password = Struct.new :name, :password, :search_words do
      def match?(query)
        name.include?(query) || search_words.include?(query)
      end
    end

    include Enumerable

    def initialize(&initializer)
      @passwords = {}
      initializer.call self if initializer
    end

    def each(&block)
      @passwords.values.each(&block)
    end

    def add(name, data)
      @passwords[name] = Password.new name,
                                      data.fetch('password'),
                                      data.fetch('search_words')
    end

    def ==(passwords)
      @passwords == passwords.instance_variable_get(:@passwords)
    end

    def [](name)
      @passwords[name]
    end

    def to_primitive_data
      {'passwords' => inject({}) { |pws, pw|
                        pws.merge pw.name => {
                          'password'     => pw.password,
                          'search_words' => pw.search_words,
                        }
                      }
      }
    end

    def self.from_primitive_data(primitive_data)
      new do |passwords|
        primitive_data['passwords'].each do |name, data|
          passwords.add name, data
        end
      end
    end
  end
end
