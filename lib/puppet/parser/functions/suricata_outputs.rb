require 'puppet/parser/functions'

Puppet::Parser::Functions.newfunction(:suricata_outputs, :type => :statement) do |args|
    outputs = args[0]

    outputs.each do |title,settings|
        function_create_resources(["suricata::output", { title => { :settings => settings } }])
    end
end
