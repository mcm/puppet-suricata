define suricata::partition($lvname = $name, $volgrp, $fstype, $size = "1G") {
  exec {"create ${lvname} LV":
    command => "/sbin/lvcreate -L ${size} -n ${lvname} ${volgrp}",
    unless  => "/sbin/lvs /dev/${volgrp}/${lvname}",
    notify  => Exec["format ${lvname}"], 
  }

  exec {"format ${lvname}":
    command     => "/sbin/mkfs.${fstype} /dev/${volgrp}/${lvname}",
    refreshonly => true,
  }

}
