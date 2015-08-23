class suricata::configs {
    file {"/etc/network/if-up.d/idps-interface-tuneup":
        ensure          => present,
        owner           => "root",
        group           => "root",
        mode            => "0755",
        source          => "puppet:///modules/suricata/idps-interface-tuneup",
    }

    file {"/etc/sysctl.d/99-suricata.conf":
        ensure          => present,
        owner           => "root",
        group           => "root",
        mode            => "0755",
        source          => "puppet:///modules/suricata/sysctl.d/99-suricata.conf",
#        notify          => Service["procps"],
    }

    file {"/etc/logrotate.d/suricata":
        ensure          => present,
        owner           => "root",
        group           => "root",
        mode            => "0644",
        source          => "puppet:///modules/suricata/logrotate/suricata",
    }

    $empty = "puppet:///modules/suricata/empty_file"

    concat {"/etc/suricata/threshold.conf":
      owner           => "root",
      group           => "root",
      mode            => "0644",
      tag             => ["suricata", "pulledpork"],
    }

    concat::fragment {"threshold.conf_global":
      target          => "/etc/suricata/threshold.conf",
      source          => "puppet:///modules/suricata/threshold.conf",
      order           => "01",
    }

    if ($::suricata::extra_source != "") {
      concat::fragment {"threshold.conf_extra":
        target          => "/etc/suricata/threshold.conf",
        source          => ["$::suricata::extra_source/threshold.conf", $empty],
        order           => "51",
      }
    }

    concat::fragment {"threshold.conf_local":
      target          => "/etc/suricata/threshold.conf",
      source          => ["puppet:///files/threshold.conf", $empty],
      order           => "99",
    }
}
