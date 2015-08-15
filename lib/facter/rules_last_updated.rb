if File.exists?("/usr/sbin/snort")
    snort_version = Facter::Util::Resolution.exec('/usr/sbin/snort -V 2>&1').scan(/Version (\S+)/)[0][0].gsub(".", "")
    rules_file = "/var/lib/pulledpork/snortrules-snapshot-" + snort_version + ".tar.gz"
elsif File.exists?("/usr/bin/suricata")
    rules_file = "/var/lib/pulledpork/etpro.rules.tar.gz"
else
    rules_file = ""
end

if rules_file != "" and File.exists?(rules_file)
    Facter.add("rules_last_updated") do
        setcode do
            File.mtime(rules_file).to_i
        end
    end
else
    Facter.add("rules_last_updated") do
        setcode do
            0
        end
    end
end
