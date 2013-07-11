#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the fstab_augeas_opts function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("fstab_augeas_opts").should == "function_fstab_augeas_opts"
  end

  it "should raise a ParseError if the supplied first argument is not a String" do
    lambda { scope.function_fstab_augeas_opts([]) }.should( raise_error(Puppet::ParseError) )
  end

  it "should raise a ParseError if the supplied second argument is not a String" do
    lambda { scope.function_fstab_augeas_opts(['', 0])}.should( raise_error(Puppet::ParseError) )
  end

  it "should return an array of the opts needed for augeas" do
    result = scope.function_fstab_augeas_opts(['nofail,defaults,noatime,ro,gid=5,mode=620'])
    result.should(eq([
      'set 01/opt[1] nofail',
      'set 01/opt[2] defaults',
      'set 01/opt[3] noatime',
      'set 01/opt[4] ro',
      'set 01/opt[5] gid',
      'set 01/opt[5]/value 5',
      'set 01/opt[6] mode',
      'set 01/opt[6]/value 620',
     ]))
  end

  it "should return an array of the opts needed to execute an update using augeas with the correct scope" do
    result = scope.function_fstab_augeas_opts(['nofail,defaults,noatime,ro,gid=5,mode=620', '*[spec="/dev/sda1" and file="/"]'])
    result.should(eq([
      'rm *[spec="/dev/sda1" and file="/"]/opt',
      'ins opt after *[spec="/dev/sda1" and file="/"]/vfstype[last()]',
      'set *[spec="/dev/sda1" and file="/"]/opt[1] nofail',
      'ins opt after *[spec="/dev/sda1" and file="/"]/opt[last()]',
      'set *[spec="/dev/sda1" and file="/"]/opt[2] defaults',
      'ins opt after *[spec="/dev/sda1" and file="/"]/opt[last()]',
      'set *[spec="/dev/sda1" and file="/"]/opt[3] noatime',
      'ins opt after *[spec="/dev/sda1" and file="/"]/opt[last()]',
      'set *[spec="/dev/sda1" and file="/"]/opt[4] ro',
      'ins opt after *[spec="/dev/sda1" and file="/"]/opt[last()]',
      'set *[spec="/dev/sda1" and file="/"]/opt[5] gid',
      'set *[spec="/dev/sda1" and file="/"]/opt[5]/value 5',
      'ins opt after *[spec="/dev/sda1" and file="/"]/opt[last()]',
      'set *[spec="/dev/sda1" and file="/"]/opt[6] mode',
      'set *[spec="/dev/sda1" and file="/"]/opt[6]/value 620',
    ]))
  end
end