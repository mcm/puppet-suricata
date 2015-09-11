class suricata::partitions($vg = $::hurricanedefense::partitions::os_vg) {
  partition {"suricata":
    volgrp  => $vg,
    fstype  => "xfs",
    size    => "20G",
    tag     => "suricata",
  }

  file {"/var/log/suricata":
    ensure  => directory
  }

  mount {"/var/log/suricata":
    ensure  => mounted,
    device  => "/dev/mapper/${vg}-suricata",
    atboot  => true,
    fstype  => "xfs",
    options => "nodev,nosuid,noexec",
    require => suricata::partition["suricata"],
  }

  File["/var/log/suricata"] -> Mount["/var/log/suricata"]

}
