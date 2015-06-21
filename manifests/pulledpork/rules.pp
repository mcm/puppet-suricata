class suricata::pulledpork::rules {
    $filename = "suricata-1.1.0_etpro.rules.tar.gz"

    file {"/var/lib/pulledpork/etpro.rules.tar.gz":
        ensure          => present,
        owner           => "root",
        group           => "root",
        mode            => "0640",
        source          => "puppet:///snort/rules/$filename",
        notify          => Exec["run pulledpork"],
    }

    file {"/var/lib/pulledpork/etpro.rules.tar.gz.md5":
        ensure          => present,
        owner           => "root",
        group           => "root",
        mode            => "0640",
        source          => "puppet:///snort/rules/$filename.md5",
    }

    File["/var/lib/pulledpork"] -> File["/var/lib/pulledpork/etpro.rules.tar.gz"]
}
