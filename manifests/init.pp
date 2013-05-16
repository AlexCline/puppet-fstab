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

  $res_name = "${source} ${dest} ${type} ${opts} ${ensure}"

  case $::operatingsystem {
    redhat, centos, amazon: {
      fstab::augeas { $res_name:
        source => $source,
        dest   => $dest,
        type   => $type,
        opts   => $opts,
        dump   => $dump,
        passno => $passno,
        ensure => $ensure,
      }
    }
    default: { error('Your OS isn\'t supported by the fstab module yet.') }
  }

}
