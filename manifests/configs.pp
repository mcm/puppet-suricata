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

    concat {"/etc/suricata/threshold.config":
      owner           => "root",
      group           => "root",
      mode            => "0644",
      tag             => ["suricata", "pulledpork"],
    }

    concat::fragment {"threshold.config_global":
      target          => "/etc/suricata/threshold.config",
      source          => "puppet:///modules/suricata/threshold.config",
      order           => "01",
    }

    if ($::suricata::extra_source != "") {
      concat::fragment {"threshold.config_extra":
        target          => "/etc/suricata/threshold.config",
        source          => ["$::suricata::extra_source/threshold.config", $empty],
        order           => "51",
      }
    }

    concat::fragment {"threshold.config_local":
      target          => "/etc/suricata/threshold.config",
      source          => ["puppet:///files/threshold.config", $empty],
      order           => "99",
    }
}
