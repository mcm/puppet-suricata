class suricata::pulledpork::scripts {
    file {"/usr/bin/pulledpork.pl":
        ensure          => present,
        owner           => "root",
        group           => "root",
        mode            => "0755",
        source          => "puppet:///modules/suricata/pulledpork/pulledpork.pl",
    }
}
