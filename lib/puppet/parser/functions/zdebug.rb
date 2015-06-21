require 'puppet/parser/functions'

Puppet::Parser::Functions.newfunction(:zdebug, :type => :statement) do |taco|
    debug taco
end
