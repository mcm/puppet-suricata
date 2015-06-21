class suricata::apt {
    apt::source {"suricata-stable":
        location        => "http://ppa.launchpad.net/oisf/suricata-stable/ubuntu",
        repos           => "main",
#        key             => {
#            id              => "9F6FC9DDB1324714B78062CBD7F87B2966EB736F",
#            server          => "hkp://keyserver.ubuntu.com:80"
#        },
        key             => "66EB736F",
    }
}
