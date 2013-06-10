require 'spec_helper'
require 'she_told_me_she_had_a_god_complex_i_told_her_i_was_an_atheist/command_line_binary/user_interaction'

describe Interfaces do
  specify 'CommandLineBinary::Interface implements the Interfaces::Interface interface -.-' do
    SheToldMeSheHadAGodComplexIToldHerIWasAnAtheist::CommandLineBinary::UserInteraction.should \
      substitute_for Interfaces::UserInteraction, subset: true, names: true
  end
end
