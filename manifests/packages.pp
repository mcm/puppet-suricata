class suricata::packages {
    if ($::suricata::auto_update) {
        $ensure = "2.1~beta4-0ubuntu12"
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

    package {"ethtool":
        ensure          => installed,
        tag             => "suricata",
    }
}
