# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation errors
# and view a log of events) or by fully applying the test in a virtual environment
# (to compare the resulting system state to the desired state).
#
# Learn more about module testing here: http://docs.puppetlabs.com/guides/tests_smoke.html
#

fstab { 'A test fstab entry':
  source => '/dev/sdb2',
  dest   => '/mnt/foobar',
  type   => 'ext4',
}

fstab { 'Another test fstab entry':
  source => 'ahost:/data',
  dest   => '/data',
  type   => 'nfs',
  opts   => 'defaults,noatime,nofail,ro',
  dump   => 0,
  passno => 0,
}

fstab { 'Remove A test fstab entry':
  source => '/dev/sdb2',
  dest   => '/mnt/foobar',
  type   => 'ext4',
  ensure => absent,
}

fstab { 'Remove Another test fstab entry':
  source => 'ahost:/data',
  dest   => '/data',
  type   => 'nfs',
  ensure => absent,
}
