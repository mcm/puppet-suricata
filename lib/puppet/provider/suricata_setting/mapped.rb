require 'puppetx/filemapper'
require 'psych'
require 'yaml'

Puppet::Type.type(:suricata_setting).provide(:mapped) do
  include PuppetX::FileMapper

  desc "Generic filemapper provider for suricata_setting"

  def select_file
    "/etc/suricata/suricata.yaml"
  end

  def self.target_files
    ["/etc/suricata/suricata.yaml"]
  end

  def self.conv_to_s(value)
    if value.is_a? Symbol
      ":#{value}"
    else
      value
    end
  end

  def self.conv_to_sym(value)
    if value.chars.first == ':'
      value[1..-1].to_sym
    else
      value
    end
  end

  def self.properties_to_hash(array)
    hashes = Array.new
    array.each do |r|
      hashes << r[:key].split('.').reverse.inject(r[:value]) do |a,n|
        { n => a }
      end
    end
    result = Hash.new
    hashes.each do |hash|
      deep_merge!(result, hash)
    end
    result
  end

  def self.hash_to_properties(value)
    r_hash_to_properties('', value)
  end

  def self.r_hash_to_properties(key, value)
    return [{:value => value}] unless value.is_a?(Hash)
    result = Array.new
    value.each do |k,v|
      result << r_hash_to_properties(k,v).map do |elem|
        k = conv_to_s(k)
        elem[:key] = elem[:key] ? "#{k}.#{elem[:key]}" : k
        elem
      end
    end
    result.flatten
  end

  def self.deep_merge!(hash1,hash2)
    hash2.each_key do |key|
      case
        when (hash1[key].is_a?(Hash) and hash2[key].is_a?(Hash))
          deep_merge!(hash1[key], hash2[key])
        when hash1[key].nil?
          hash1[key] = hash2[key]
        else
          raise "Unable to cleanly merge suricata_setting resources: #{hash1[key]} | #{hash2[key]}"
      end
    end
  end

  def self.transform_keys_to_strings(value)
    return value if not value.is_a?(Hash)
    hash = value.inject({}) do |memo,(k,v)|
      memo[conv_to_sym(k)] = transform_keys_to_strings(v)
      memo
    end
    return hash
  end

  def self.parse_file(filename, contents)
    # Load an existing or instantiate a new data structure. Works for:
    #   - existing yaml files
    #   - existing empty files
    #   - non-existent files
    yaml = (File.exists?(filename) ? YAML.load_file(filename) : {}) || {}

    properties_hashes = hash_to_properties(yaml)
    properties_hashes.map! do |resource|
      resource[:name]   = resource[:key].to_s
      resource[:target] = "/etc/suricata/suricata.yaml"
      resource[:type]   = case resource[:value]
      when Fixnum
        'integer'
      when Symbol
        'symbol'
      when FalseClass, TrueClass
        'boolean'
      else
        resource[:value].class.to_s.downcase
      end

      # Hack alert. This is done since because we have :array_matching=>:all
      # in the type, all values regardless of Type (array, string, etc) are
      # given as an array of values. Ok fine. We'll consider this as an array
      # of values so that stuff read in from the file is represented in the
      # same way as stuff defined in Puppet
      resource[:value]  = [resource[:value]].flatten

      resource
    end
    properties_hashes
  end

  def self.format_file(filename, providers)
    properties_hashes = providers.inject([]) do |arr, provider|
      hash = Hash.new
      hash[:name]   = provider.key.to_s
      hash[:target] = "/etc/suricata/suricata.yaml"
      hash[:key]    = provider.key
      hash[:value]  = case provider.type.to_sym
      when :array, :hash
        provider.value
      when :string
        provider.value.first.to_s
      when :symbol
        provider.value.first.to_sym
      when :fixnum, :integer
        provider.value.first.to_i
      when :float
        provider.value.first.to_f
      when :trueclass, :falseclass, :boolean
        if provider.key =~ /^logging./
          provider.value.first.to_s =~ /^true$/i ? "true" : "false"
        else
          provider.value.first.to_s =~ /^true$/i ? "yes" : "no"
        end
      when :nilclass
        nil
      else
        Puppet.warning "unexpected type #{provider.type}; defaulting to string"
        provider.value.to_s
      end
      arr << hash
    end
    content_hash = properties_to_hash(properties_hashes)
    def YAML.dump o, io = nil, options = {}
      if Hash === io
        options = io
        io      = nil
      end

      visitor = Psych::Visitors::YAMLTree.new options
      visitor << o
      visitor.tree.to_yaml io, options
    end
    transform_keys_to_strings(content_hash).psych_to_yaml(:header => true) << "\n"
  end

end
