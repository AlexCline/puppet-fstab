fstab
=====

The fstab module helps puppet manage entries in fstab.

This module will add and remove entries from fstab.  It will not manage mount
points or permissions.  If you need to manage directories for mounts, check
out the `AlexCline-mounts` module.

Examples
--------

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

Dependencies
------------

This module depends on [PuppetLab's stdlib](http://forge.puppetlabs.com/puppetlabs/stdlib) module.


Support
-------

Please file tickets and issues using [GitHub Issues](https://github.com/AlexCline/fstab/issues)


License
-------
   Copyright 2013 Alex Cline <alex.cline@gmail.com>

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
