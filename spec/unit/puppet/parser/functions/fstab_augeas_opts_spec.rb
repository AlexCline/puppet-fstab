#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the fstab_augeas_opts function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("fstab_augeas_opts").should == "function_fstab_augeas_opts"
  end

  it "should raise a ParseError if the supplied argument is not a String" do
    lambda { scope.function_fstab_augeas_opts([]) }.should( raise_error(Puppet::ParseError))
  end

  it "should return an array of the opts needed for augeas" do
    result = scope.function_fstab_augeas_opts(['nofail,defaults,noatime,ro'])
    result.should(eq([
      'set 01/opt[1] nofail',
      'set 01/opt[2] defaults',
      'set 01/opt[3] noatime',
      'set 01/opt[4] ro',
     ]))
  end

end