class suricata::settings {
    $default_settings = {
        "logging.outputs"   => [
            { "console"         => {
                "enabled"           => "yes",
            } },
            { "file"            => {
                "enabled"           => "yes",
                "filename"          => "/var/log/suricata.log",
            } },
        ],
        "rule-files"                            => ["suricata.rules", "hd.rules", "local.rules"],
        "runmode"                               => "workers",
        "stats.interval"                        => "60",
        "stream.reassembly.chunk-prealloc"      => "500",
        "stream.reassembly.depth"               => "10mb",
        "stream.reassembly.memcap"              => "512mb",
        "stream.memcap"                         => "512mb",
        "stream.checksum-validation"            => "no",
        "stream.inline"                         => "no",
    }

    if ($::suricata::settings != undef) {
        $settings = merge($default_settings, $::suricata::settings)
    } else {
        $settings = $default_settings
    }

    suricata_settings($settings)

    Package["suricata"] -> Suricata_setting<| |>
    Suricata_setting<| |> ~> Exec["verify suricata config"]
    Suricata_setting<| |> ~> Service["suricata"]
}
