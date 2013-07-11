# define fstab::augeas::define

define fstab::augeas::update(
  $source = undef,
  $dest   = undef,
  $type   = undef,
  $opts   = undef,
  $dump   = 0,
  $passno = 0) {

  # Get the fstab_file for this OS
  include fstab::variables

  $fstab_match_line = "*[spec='${source}' and file='${dest}']"

  $fstab_part_one = [
    "set ${fstab_match_line}/vfstype ${type}",
  ]

  # This will return the magic for updating the opts for an existing entry
  $fstab_part_two = fstab_augeas_opts($opts, $fstab_match_line)

  $fstab_part_three = [
    "set ${fstab_match_line}/dump ${dump}",
    "set ${fstab_match_line}/passno ${passno}",
  ]

  $fstab_parts_onetwo = concat($fstab_part_one, $fstab_part_two)
  $fstab_changes = concat($fstab_parts_onetwo, $fstab_part_three)

  # This augeas resource will update all the entries in fstab if an entry
  # exist with the provided source and destination.
  augeas { "Update ${name}":
    context => "/files${fstab::variables::fstab_file}",
    changes => $fstab_changes,
    onlyif  => "match ${fstab_match_line} size != 0",
  }
}