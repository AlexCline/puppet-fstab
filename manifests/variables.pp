# class fstab::variables

class fstab::variables {
  $fstab_file = $::operatingsystem ? {
    /(RedHat|CentOS|Amazon)/ => '/etc/fstab',
    default                => '/dev/null',
  }
}