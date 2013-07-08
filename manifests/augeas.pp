# define fstab::augeas

define fstab::augeas(
  $source = undef,
  $dest   = undef,
  $type   = undef,
  $opts   = undef,
  $dump   = 0,
  $passno = 0,
  $ensure = 'present'){

  # Get the fstab_file for this OS
  include fstab::variables

  case $ensure {
    'present': {
      # The ordering of the changes in augeas matters, so we'll build
      # the changes, step by step and concat them together.
      # The order is: spec, file, vfstype*, opt*, dump?, passno?

      $fstab_part_one = [
        "set 01/spec ${source}",
        "set 01/file ${dest}",
        "set 01/vfstype ${type}",
      ]

      $fstab_part_two = fstab_augeas_opts($opts)

      $fstab_part_three = [
        "set 01/dump ${dump}",
        "set 01/passno ${passno}",
      ]

      # Concat parts one and two into onetwo, then concat onetwo and three
      $fstab_parts_onetwo = concat($fstab_part_one, $fstab_part_two)
      $fstab_changes      = concat($fstab_parts_onetwo, $fstab_part_three)

      augeas { $name:
        context => "/files${fstab::variables::fstab_file}",
        changes => $fstab_changes,
        onlyif  => "match *[spec='${source}' and file='${dest}' and vfstype='${type}'] size == 0",
#    notify  => Exec["/bin/mount ${dest}"],
#    require => File[$dest_dirtree],
      }
    }
    'absent': {
      augeas { $name:
        context => "/files${fstab::variables::fstab_file}",
        changes => [
          "rm *[spec='${source}' and file='${dest}' and vfstype='${type}']",
        ],
        onlyif  => "match *[spec='${source}' and file='${dest}' and vfstype='${type}'] size > 0"
      }
    }
  }
}
