module SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist
  class Passwords
    Password = Struct.new :name, :login, :password, :search_string do
      def match?(query)
        name.include?(query) || search_string.include?(query)
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

    def empty?
      @passwords.empty?
    end

    def add(name, data)
      @passwords[name] = Password.new name,
                                      data.fetch('login'),
                                      data.fetch('password'),
                                      data.fetch('search_string')
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
                          'login'         => pw.login,
                          'password'      => pw.password,
                          'search_string' => pw.search_string,
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
