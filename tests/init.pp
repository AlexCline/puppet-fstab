# fstab module test resources.

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
  ensure  => absent,
  source  => '/dev/sdb2',
  dest    => '/mnt/foobar',
  type    => 'ext4',
  require => Fstab['A test fstab entry'],
}

fstab { 'Remove Another test fstab entry':
  ensure  => absent,
  source  => 'ahost:/data',
  dest    => '/data',
  type    => 'nfs',
  require => Fstab['Another test fstab entry'],
}

fstab {'AWS Root Drive':
  source => 'LABEL=cloudimg-rootfs',
  dest   => '/',
  type   => 'ext4',
  opts   => 'defaults,acl',
  dump   => 0,
  passno => 0,
}

fstab {'Revert AWS Root Drive':
  source  => 'LABEL=cloudimg-rootfs',
  dest    => '/',
  type    => 'ext4',
  opts    => 'defaults,acl',
  dump    => 0,
  passno  => 0,
  require => Fstab['AWS Root Drive'],
}