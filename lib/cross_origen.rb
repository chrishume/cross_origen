require 'origen'
require_relative '../config/application.rb'

module CrossOrigen
  autoload :XMLDoc,       'cross_origen/xml_doc'
  autoload :Headers,      'cross_origen/headers'
  autoload :Ralf,         'cross_origen/ralf'
  autoload :IpXact,       'cross_origen/ip_xact'
  autoload :DesignSync,   'cross_origen/design_sync'
  autoload :CMSISSVD,     'cross_origen/cmsis_svd'

  # Basic object that is used to capture imported data and then export/save
  # it to Origen format
  class Model
    include Origen::Model
  end

  # Returns true if the --refresh switch was passed to the current Origen command
  def self.refresh?
    @refresh || false
  end

  def self.include_timestamp?
    instance_variable_defined?(:@include_timestamp) ? @include_timestamp : true
  end

  def self.include_timestamp=(val)
    @include_timestamp = val
  end

  def instance_respond_to?(method_name)
    public_methods.include?(method_name)
  end

  def cr_import(options = {})
    options = {
      include_timestamp: true
    }.merge(options)
    CrossOrigen.include_timestamp = options[:include_timestamp]
    file = cr_file(options)
    cr_translator(file, options).import(file, options)
  end

  def to_ralf(options = {})
    cr_ralf.owner_to_ralf(options)
  end

  def to_ip_xact(options = {})
    cr_ip_xact.owner_to_xml(options)
  end
  alias_method :to_ipxact, :to_ip_xact

  def to_header(options = {})
    cr_headers.owner_to_header(options)
  end

  # Tries the given methods and returns the first one to return a value,
  # ultimately returns nil if no value is found.
  def cr_try(*methods)
    methods.each do |method|
      if self.respond_to?(method)
        val = send(method)
        return val if val
      end
    end
    nil
  end

  # Returns an instance of the DesignSync interface
  def cr_design_sync
    @cr_design_sync ||= DesignSync.new(self)
  end

  def cr_headers
    @cr_headers ||= Headers.new(self)
  end

  def cr_ralf
    @cr_ralf ||= Ralf.new(self)
  end

  def cr_ip_xact
    @cr_ip_xact ||= IpXact.new(self)
  end

  def cr_cmsis_svd
    @cr_cmsis_svd ||= CMSISSVD.new(self)
  end

  private

  # Returns an instance of the translator for the format of the given file
  def cr_translator(file, options = {})
    snippet = IO.read(file, 2000)  # Read first 2000 characters
    case snippet
    when /spiritconsortium/
      cr_ip_xact
    when /CMSIS-SVD.xsd/
      cr_cmsis_svd
    else
      # Give IP-XACT another opportunity if it looks like partial IP-XACT doc
      if snippet =~ /<spirit:register>/
        options[:fragment] = true
        cr_ip_xact
      else
        fail "Unknown file format for file: #{file}"
      end
    end
  end

  # Returns a local path to the given file defined by the options.
  def cr_file(options = {})
    if options[:path]
      options[:path]
    elsif options[:vault]
      cr_design_sync.fetch(options)
    else
      fail 'You must supply a :path or :vault option pointing to the import file!'
    end
  end
end
