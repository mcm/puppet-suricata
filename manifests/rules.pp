define suricata::rulesfile($global=true, $extra=true, $local=true) {
    concat {"/etc/suricata/rules/${title}":
        owner           => "root",
        group           => "root",
        mode            => "0644",
        tag             => ["suricata", "pulledpork"],
    }

    $empty = "puppet:///modules/suricata/empty_file"

    if ($global) {
        concat::fragment {"suricata_rules_${title}_global":
            target          => "/etc/suricata/rules/${title}",
            source          => "puppet:///modules/suricata/rules/${title}",
            order           => "01",
        }
    }

    if ($::suricata::extra_source != "" and $extra) {
        concat::fragment {"suricata_rules_${file}_extra":
            target          => "/etc/suricata/rules/${title}",
            source          => ["$::suricata::extra_source/rules/${title}", $empty],
            order           => "51",
        }
    }

    if ($local) {
        concat::fragment {"suricata_rules_${title}_local":
            target          => "/etc/suricata/rules/${title}",
            source          => ["puppet:///files/rules/${title}", $empty],
            order           => "99",
        }
    }
}

class suricata::rules {
    # HD rules are provided by HL
    suricata::rulesfile{"hd.rules": }

    # Local rules are provided by the customer
    suricata::rulesfile{"local.rules":
        global          => false,
    }
}
