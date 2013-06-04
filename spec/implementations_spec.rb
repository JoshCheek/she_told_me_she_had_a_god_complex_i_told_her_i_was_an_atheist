require 'spec_helper'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/command_line_binary/interface'

describe Interfaces do
  specify 'CommandLineBinary::Interface implements the Interfaces::Interface interface -.-' do
    SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist::CommandLineBinary::Interface.should \
      substitute_for Interfaces::Interface, subset: true, names: true
  end
end
