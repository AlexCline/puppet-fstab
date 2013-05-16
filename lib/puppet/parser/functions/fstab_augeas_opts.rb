#
# fstab_augeas_opts.rb
#

module Puppet::Parser::Functions
  newfunction(:fstab_augeas_opts, :type => :rvalue, :doc => <<-EOS
This function accepts a comma separated string of the opts needed for an fstab
entry.  It will return an array of the augeas changes needed.

*Examples:*

    fstab_augeas_opts(['nofail,defaults,noatime,ro,gid=5,mode=620'])
    Will return: [
      'set 01/opt[1] nofail',
      'set 01/opt[2] defaults',
      'set 01/opt[3] noatime',
      'set 01/opt[4] ro',
      'set 01/opt[5] gid',
      'set 01/opt[5]/value 5',
      'set 01/opt[6] mode',
      'set 01/opt[6]/value 620',
    ]

You can use the array of augeas opts when creating a NFS mount like so:

    $opts = 'defaults,noatime,ro'
    $fstab_changes_one = [
      'set 01/spec host.example.com:/share',
      'set 01/file /mount/point',
      'set 01/vfstype nfs'
    ]

    $fstab_changes_two = [
      'set 01/dump 0',
      'set 01/passno 0',
    ]

    # Concat parts one and two into onetwo, then concat onetwo and three
    $fstab_parts_onetwo = concat($fstab_part_one, $fstab_part_two)
    $fstab_changes      = concat($fstab_parts_onetwo, $fstab_part_three)
    
    augeas { "Create mount from 'host.example.com:/share' to /mount/point":
      context => '/files/etc/fstab',
      changes => $fstab_changes,
      require => File[
    }

$fstab_changes_real will be:

    [ 'set 01/spec host.example.com:/share',
      'set 01/file /mount/point',
      'set 01/vfstype nfs',
      'set 01/opt[1] defaults',
      'set 01/opt[2] noatime',
      'set 01/opt[3] ro',
      'set 01/opt[5] gid',
      'set 01/opt[5]/value 5',
      'set 01/opt[6] mode',
      'set 01/opt[6]/value 620',
      'set 01/dump 0',
      'set 01/passno 0',
    ]

    EOS
  ) do |arguments|
    opts = arguments[0]

    unless opts.is_a?(String)
      raise Puppet::ParseError, "fstab_augeas_opts(): expected first argument to be a String, got #{opts.inspect}"
    end

    result = []

    opts.split(',').each_with_index do |opt, idx|
      value = opt.split '='
      result << "set 01/opt[#{idx+1}] #{value[0]}"
      # If there is a second item in the array, then we got a key and value
      result << "set 01/opt[#{idx+1}]/value #{value[1]}" if !value[1].nil?
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :