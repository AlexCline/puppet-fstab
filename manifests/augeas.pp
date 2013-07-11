# define fstab::augeas

define fstab::augeas(
  $source = undef,
  $dest   = undef,
  $type   = undef,
  $opts   = undef,
  $dump   = 0,
  $passno = 0,
  $ensure = 'present'){

  case $ensure {
    'present': {

      fstab::augeas::update { $name:
        source => $source,
        dest   => $dest,
        type   => $type,
        opts   => $opts,
        dump   => $dump,
        passno => $passno,
      }

      fstab::augeas::new { $name:
        source => $source,
        dest   => $dest,
        type   => $type,
        opts   => $opts,
        dump   => $dump,
        passno => $passno,
      }

      Fstab::Augeas::Update[$name] -> Fstab::Augeas::New[$name]

    }
    'absent': {
      augeas { $name:
        context => "/files${fstab::variables::fstab_file}",
        changes => [
          "rm ${fstab_match_line}",
        ],
        onlyif  => "match ${fstab_match_line} size > 0"
      }
    }
    default: {
      err("fstab: Invalid value specified for 'ensure' parameter.  Got ${ensure}")
    }
  }
}
