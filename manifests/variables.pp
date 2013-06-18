# class fstab::variables

class fstab::variables {
  $fstab_file = $::osfamily ? {
    'RedHat'    => '/etc/fstab',
    'Debian'    => '/etc/fstab',
    'Suse'      => '/etc/fstab',
    'Solaris'   => '/etc/fstab',
    'ArchLinux' => '/etc/fstab',
    'Mandrake'  => '/etc/fstab',
    default     => '/dev/null',
  }
}
