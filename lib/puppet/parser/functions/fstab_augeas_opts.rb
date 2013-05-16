#
# fstab_augeas_opts.rb
#

module Puppet::Parser::Functions
  newfunction(:fstab_augeas_opts, :type => :rvalue, :doc => <<-EOS
This function accepts a comma separated string of the opts needed for an fstab
entry.  It will return an array of the augeas changes needed.

*Examples:*

    fstab_augeas_opts(['nofail,defaults,noatime,ro'])
    Will return: [
      'set 01/opt[1] nofail',
      'set 01/opt[2] defaults',
      'set 01/opt[3] noatime',
      'set 01/opt[4] ro',
    ]

You can use the array of augeas opts when creating a NFS mount like so:

    $opts = 'defaults,noatime,ro'
    $fstab_changes = [
      'set 01/spec host.example.com:/share',
      'set 01/file /mount/point',
      'set 01/vfstype nfs',
      'set 01/dump 0',
      'set 01/passno 0',
    ]

    $fstab_changes_real = concat($fstab_changes, fstab_augeas_opts($opts))

    augeas { "Create mount from 'host.example.com:/share' to /mount/point":
      context => '/files/etc/fstab',
      changes => $fstab_changes_real,
      require => File[
    }

$fstab_changes_real will be:
[ 'set 01/spec host.example.com:/share',
  'set 01/file /mount/point',
  'set 01/vfstype nfs',
  'set 01/dump 0',
  'set 01/passno 0',
  'set 01/opt[1] defaults',
  'set 01/opt[2] noatime',
  'set 01/opt[3] ro', ]


    EOS
  ) do |arguments|
    opts = arguments[0]

    unless opts.is_a?(String)
      raise Puppet::ParseError, "fstab_augeas_opts(): expected first argument to be a String, got #{opts.inspect}"
    end

    result = []

    opts.split(',').each_with_index do |opt, idx|
      result << "set 01/opt[#{idx+1}] #{opt}"
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :