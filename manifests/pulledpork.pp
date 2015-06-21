class suricata::pulledpork {
    include suricata::pulledpork::configs
    include suricata::pulledpork::dependencies
    include suricata::pulledpork::scripts
    #include suricata::pulledpork::services

    if ($::suricata::auto_update_rules) {
        include suricata::pulledpork::rules
    }

    file {"/etc/pulledpork":
        ensure          => directory,
        owner           => "root",
        group           => "root",
        mode            => "0755",
    }

    file {"/var/log/pulledpork":
        ensure          => directory,
        owner           => "root",
        group           => "root",
        mode            => "0700",
    }

    file {"/var/lib/pulledpork":
        ensure          => directory,
        owner           => "root",
        group           => "root",
        mode            => "0700",
    }

    exec {"run pulledpork":
        command         => "/usr/bin/pulledpork.pl -c /etc/pulledpork/pulledpork.conf -n -P",
        refreshonly     => true,
    }
    File["/var/log/pulledpork"] -> Exec["run pulledpork"]

    if ($::pulledpork_last_run < $::rules_last_updated) {
        Exec<| title=="run pulledpork" |> {
            refreshonly         => false,
        }
    }

    Exec["run pulledpork"] ~> Exec["verify suricata config"]
}
