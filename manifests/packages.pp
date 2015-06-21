class suricata::packages {
    if ($::suricata::auto_update) {
        $ensure = "latest"
    } else {
        $ensure = "installed"
    }

    package {"jq":
        ensure          => installed,
    }

    package {"suricata":
        ensure          => $ensure,
        tag             => "suricata",
    }
}
