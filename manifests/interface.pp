define suricata::interface($threads="auto", $cluster_id=99, $cluster_type="cluster_flow", $defrag="true") {
    $interface = {
        "interface"         => $title,
        "threads"           => $threads,
        "cluster-id"        => $cluster_id,
        "cluster-type"      => $cluster_type,
        "defrag"            => $defrag,
    }
    zdebug($interface)

    $listen_mode = $::suricata::listen_mode

    Suricata_setting<| title==$listen_mode |> {
        value           +> [$interface],
    }
}
