class suricata(
    $interfaces             = undef,
    $auto_update            = true,
    $auto_update_rules      = true,
    $listen_mode            = "af-packet",
    $settings               = undef,
    $outputs                = undef,
    $merge_outputs          = true,
) {
    if (versioncmp($::rubyversion, "1.9") >= 0) {
        include suricata::apt
        include suricata::configs
        include suricata::interfaces
        include suricata::outputs
        include suricata::packages
        include suricata::pulledpork
        include suricata::rules
        include suricata::services
        include suricata::settings

        exec {"verify suricata config":
            command         => "/usr/bin/suricata -T",
            refreshonly     => true,
        }
    }
}
