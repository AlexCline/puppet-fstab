#
# fstab_augeas_opts.rb
#

module Puppet::Parser::Functions
  newfunction(:fstab_augeas_opts, :type => :rvalue, :doc => <<-EOS
This function accepts a comma separated string of the opts needed for an fstab
entry and an optional second argument of the scope for the resulting opts.
It will return an array of the augeas changes needed.

*Examples:*

**Creating a New fstab Entry:**

    fstab_augeas_opts('nofail,defaults,noatime,ro,gid=5,mode=620')
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

    $opts = nofail,defaults,noatime,ro,gid=5,mode=620'
    $fstab_changes_one = [
      'set 01/spec host.example.com:/share',
      'set 01/file /mount/point',
      'set 01/vfstype nfs'
    ]

    $fstab_changes_two = fstab_augeas_opts($opts)

    $fstab_changes_three = [
      'set 01/dump 0',
      'set 01/passno 0',
    ]

    # Concat parts one and two into onetwo, then concat onetwo and three
    $fstab_parts_onetwo = concat($fstab_part_one, $fstab_part_two)
    $fstab_changes      = concat($fstab_parts_onetwo, $fstab_part_three)
    
    augeas { "Create mount from 'host.example.com:/share' to /mount/point":
      context => '/files/etc/fstab',
      changes => $fstab_changes,
    }

$fstab_changes will be:

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

**Updating an Existing fstab Entry:**

You can also provide an optional second parameter which is the scope of the opts returned:

    fstab_augeas_opts('nofail,defaults,noatime,ro,gid=5,mode=620', '*[spec="/dev/sda1" and file="/"]')
    Will return: [
      'rm *[spec="/dev/sda1" and file="/"]/opt',
      'ins opt after *[spec="/dev/sda1" and file="/"]/vfstype[last()]',
      'set *[spec="/dev/sda1" and file="/"]/opt[1] defaults',
      'ins opt after *[spec="/dev/sda1" and file="/"]/opt[last()]',
      'set *[spec="/dev/sda1" and file="/"]/opt[2] noatime',
      'ins opt after *[spec="/dev/sda1" and file="/"]/opt[last()]',
      'set *[spec="/dev/sda1" and file="/"]/opt[3] ro',
      'ins opt after *[spec="/dev/sda1" and file="/"]/opt[last()]',
      'set *[spec="/dev/sda1" and file="/"]/opt[5] gid',
      'set *[spec="/dev/sda1" and file="/"]/opt[5]/value 5',
      'ins opt after *[spec="/dev/sda1" and file="/"]/opt[last()]',
      'set *[spec="/dev/sda1" and file="/"]/opt[6] mode',
      'set *[spec="/dev/sda1" and file="/"]/opt[6]/value 620',
    ]

In order to properly order the opts, all opts must be removed, and then readded in-order
after the last 'vfstype' node.  This is because the change must match the following tree:

    {spec}{file}{vfstype}({vfstype})*{opt}({opt})*({dump}({passno})?)?


This can be used when updating opts used for existing mount points.

    $opts = 'nofail,defaults,noatime,ro,gid=5,mode=620'
    $scope = '*[spec="/dev/sda1" and file="/"]'
    $fstab_changes_one = [
      "set ${scope}/vfstype ext4"
    ]

    $fstab_changes_two = [
      'set ${scope}/dump 1',
      'set ${scope}/passno 1',
    ]

    # Concat parts one and two into onetwo, then concat onetwo and three
    $fstab_parts_onetwo = concat($fstab_part_one, $fstab_part_two)
    $fstab_changes      = concat($fstab_parts_onetwo, $fstab_part_three)
    
    augeas { "Update mount at ${scope}":
      context => '/files/etc/fstab',
      changes => $fstab_changes,
      onlyif  => "match ${scope} size != 0",
    }

$fstab_changes_real will be:

    [ 'set *[spec="/dev/sda1" and file="/"]/vfstype ext4',
      'rm *[spec="/dev/sda1" and file="/"]/opt',
      'ins opt after *[spec="/dev/sda1" and file="/"]/vfstype[last()]',
      'set *[spec="/dev/sda1" and file="/"]/opt[1] defaults',
      'ins opt after *[spec="/dev/sda1" and file="/"]/opt[last()]',
      'set *[spec="/dev/sda1" and file="/"]/opt[2] noatime',
      'ins opt after *[spec="/dev/sda1" and file="/"]/opt[last()]',
      'set *[spec="/dev/sda1" and file="/"]/opt[3] ro',
      'ins opt after *[spec="/dev/sda1" and file="/"]/opt[last()]',
      'set *[spec="/dev/sda1" and file="/"]/opt[5] gid',
      'set *[spec="/dev/sda1" and file="/"]/opt[5]/value 5',
      'ins opt after *[spec="/dev/sda1" and file="/"]/opt[last()]',
      'set *[spec="/dev/sda1" and file="/"]/opt[6] mode',
      'set *[spec="/dev/sda1" and file="/"]/opt[6]/value 620',
      'set *[spec="/dev/sda1" and file="/"]/dump 1',
      'set *[spec="/dev/sda1" and file="/"]/passno 1',
    ]

    EOS
  ) do |arguments|
    opts = arguments[0]
    if arguments[1].nil?
      scope = "01" # The default of '01' causes augeas to create a new entry.
    else
      scope = arguments[1] 
    end

    unless opts.is_a?(String)
      raise Puppet::ParseError, "fstab_augeas_opts(): expected first argument to be a String, got #{opts.inspect}"
    end

    unless scope.is_a?(String)
      raise Puppet::ParseError, "fstab_augeas_opts(): expected second argument to be a String, got #{scope.inspect}"
    end

    result = []

    # If there's no scope specified as an argument, then assume we're updating an existing entry.
    # First, remove all opts
    # Second, insert a new opt node after the last vfstype node.
    if scope != "01"
      result << "rm #{scope}/opt"
      result << "ins opt after #{scope}/vfstype[last()]"
    end

    opts.split(',').each_with_index do |opt, idx|
      value = opt.split '='

      # If there's a custom scope and this isn't the first opt
      # insert a new opt node after the last opt node.
      result << "ins opt after #{scope}/opt[last()]" if (scope != "01" && idx > 0)

      # Set the opt node (augeas numbering is 1..n) to the value specified
      result << "set #{scope}/opt[#{idx+1}] #{value[0]}"

      # If there is a second item in the array, then we got a key and value
      result << "set #{scope}/opt[#{idx+1}]/value #{value[1]}" if !value[1].nil?
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :