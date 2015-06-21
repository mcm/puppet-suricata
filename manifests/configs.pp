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
}
