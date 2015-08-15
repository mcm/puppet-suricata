define suricata::pulledpork::configfile($file=$title, $global=true, $extra=true, $local=true) {
    concat {"/etc/pulledpork/${file}.conf":
        owner           => "root",
        group           => "root",
        mode            => "0644",
        tag             => ["suricata", "pulledpork"],
    }

    if ($global) {
        concat::fragment {"${file}_global":
            target          => "/etc/pulledpork/${file}.conf",
            source          => "puppet:///modules/suricata/pulledpork/${file}.conf",
            order           => "00",
        }
    }

    if ($::suricata::extra_source != "" and $extra) {
        concat::fragment {"${file}_extra":
            target          => "/etc/pulledpork/${file}.conf",
            source          => "$::suricata::extra_source/pulledpork/${file}.conf",
            order           => "50",
        }
    }

    if ($local) {
        concat::fragment {"${file}_local":
            target          => "/etc/pulledpork/${file}.conf",
            source          => "puppet:///files/pulledpork/${file}.conf",
            order           => "99",
        }
    }
}

class suricata::pulledpork::configs {
    suricata::pulledpork::configfile {"disablesid": }
    suricata::pulledpork::configfile {"enablesid": }
    suricata::pulledpork::configfile {"modifysid": }
    suricata::pulledpork::configfile {"dropsid": }

    suricata::pulledpork::configfile {"pulledpork":
        extra           => false,
        local           => false,
    }

    File["/etc/pulledpork"] -> Suricata::Pulledpork::Configfile<| |>
    #Package<| tag=="pulledpork" |> -> Suricata::Pulledpork::Configfile<| |>
    Suricata::Pulledpork::Configfile<| |> ~> Exec["run pulledpork"]

    file {"/etc/logrotate.d/pulledpork":
        ensure          => present,
        owner           => "root",
        group           => "root",
        mode            => "0644",
        source          => "puppet:///modules/suricata/logrotate/pulledpork",
    }
}
