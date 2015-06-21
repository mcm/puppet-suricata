class suricata::services {
    service {"suricata":
        ensure          => running
    }
    Exec["verify suricata config"] -> Service["suricata"]

    File<| tag=="suricata" |> ~> Service["suricata"]
    Package<| tag=="suricata" |> -> Service["suricata"]
}
