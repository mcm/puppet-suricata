require 'puppet/parser/functions'

Puppet::Parser::Functions.newfunction(:suricata_settings, :type => :statement) do |args|
    settings = args[0]

    settings.each do |title,value|
        function_create_resources(["suricata_setting", { title => { :value => value } }])
    end
end
