require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/callable'

callable = SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist::Callable
describe callable do
  let :klass do
    Class.new do
      def call
        names_and_values = instance_variables
          .map { |name| name.to_s.sub(/^@/, '') }
          .map { |name| [name, send(name)] }
        Hash[names_and_values]
      end
    end
  end

  it 'allows translates .call(*args) to .new(*args).initialize' do
    callable.call klass, :abcd, :efgh
    klass.call(1, 2).should == {"abcd" => 1, "efgh" => 2}
  end

  it 'raises an argument error if given the wrong number of arguments' do
    callable.call klass, :abcd, :efgh
    expect { klass.call 1       }.to raise_error ArgumentError, /1 for 2/
    expect { klass.call 1, 2, 3 }.to raise_error ArgumentError, /3 for 2/
  end
end
