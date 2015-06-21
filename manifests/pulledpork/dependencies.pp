class suricata::pulledpork::dependencies {
    $depends = [
        "libio-socket-ssl-perl",
        "libcrypt-ssleay-perl",
        "ca-certificates",
        "libwww-perl"
    ]

    package {$depends:
        ensure          => installed,
    }
}
