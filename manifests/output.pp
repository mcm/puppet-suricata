define suricata::output($settings) {
    $output = {
        "$name"         => $settings
    }

    Suricata_setting<| title=="outputs" |> {
        value           +> [$output],
    }
}
