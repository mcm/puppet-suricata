if File.exists?("/etc/snort/rules/snort.rules")
    Facter.add("pulledpork_last_run") do
        setcode do
            File.mtime("/etc/snort/rules/snort.rules").to_i
        end
    end
elsif File.exists?("/etc/suricata/rules/suricata.rules")
    Facter.add("pulledpork_last_run") do
        setcode do
            File.mtime("/etc/suricata/rules/suricata.rules").to_i
        end
    end
else
    Facter.add("pulledpork_last_run") do
        setcode do
            0
        end
    end
end
