class suricata::outputs {
    $default_outputs = {
        "eve-log"           => {
            "enabled"           => "yes",
            "filetype"          => "regular",
            "filename"          => "eve.json",
            "types"             => [
                { "alert"             => {
                    "xff"               => {
                        "enabled"           => "yes",
                        "mode"              => "extra-data",
                        "deployment"        => "reverse",
                        "header"            => "X-Forwarded-For",
                    },
                } },
                { "http"              => {
                    "extended"          => "yes",
                } },
                { "dns"               => {
                } },
                { "tls"               => {
                    "extended"          => "yes",
                } },
                { "files"             => {
                    "force-magic"       => "yes",
                    "force-md5"         => "yes",
                } },
                "smtp",
                "ssh",
                "flow",
            ],
        },
        "stats"             => {
            "enabled"           => "yes",
            "filename"          => "stats.log",
        },
    }

    if ($::suricata::outputs != undef) {
        if ($::suricata::merge_outputs) {
            $outputs = merge($default_outputs, $::suricata::outputs)
        } else {
            $outputs = $suricata::outputs
        }
    } else {
        $outputs = $default_outputs
    }

    @suricata_setting {"outputs":
        value           => [],
    }

    suricata_outputs($outputs)
}
