# class fstab

define fstab(
  $source = undef,
  $dest   = undef,
  $type   = undef,
  $opts   = 'defaults',
  $dump   = 0,
  $passno = 0,
  $ensure = 'present'){

  if $source == undef {
    error('The source parameter is required.')
  }

  if $dest == undef {
    error('The dest parameter is required.')
  }

  if $type == undef {
    error('The type parameter is required.')
  }

  case $::osfamily {
    redhat, debian: {
      fstab::augeas { $name:
        ensure => $ensure,
        source => $source,
        dest   => $dest,
        type   => $type,
        opts   => $opts,
        dump   => $dump,
        passno => $passno,
      }
    }
    default: { err('Your OS isn\'t supported by the fstab module yet.') }
  }

}
