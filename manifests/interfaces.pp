class suricata::interfaces {
    $default_interface = { "interface" => "default" }

    @suricata_setting {$::suricata::listen_mode:
        value           => [$default_interface],
        type            => "array",
    }

    if ($::suricata::interfaces != undef) {
        network::interface {$::suricata::interfaces:
            method          => "manual",
        }
        suricata::interface {$::suricata::interfaces: }
    }
}
