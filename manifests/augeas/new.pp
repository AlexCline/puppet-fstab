# define fstab::augeas::new

define fstab::augeas::new(
  $source = undef,
  $dest   = undef,
  $type   = undef,
  $opts   = undef,
  $dump   = 0,
  $passno = 0) {
  
  # Get the fstab_file for this OS
  include fstab::variables

  $fstab_match_line = "*[spec='${source}' and file='${dest}']"

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

  # This augeas resource will create a new line in the fstab file if an entry doesn't
  # exist with the provided source and destination.
  augeas { $name:
    context => "/files${fstab::variables::fstab_file}",
    changes => $fstab_changes,
    onlyif  => "match ${fstab_match_line} size == 0",
  }
}
