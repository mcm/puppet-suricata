class suricata::apt {
    apt::key {"oisf-apt-key":
#        key             => "9F6FC9DDB1324714B78062CBD7F87B2966EB736F",
        key             => "66EB736F",
        key_server      => "hkp://keyserver.ubuntu.com:80",
    }

    apt::source {"suricata-stable":
        location        => "http://ppa.launchpad.net/oisf/suricata-beta/ubuntu",
        repos           => "main",
     }

     Apt::Key["oisf-apt-key"] -> Apt::Source["suricata-stable"]
}
