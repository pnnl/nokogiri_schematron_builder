require "nokogiri/xml/schematron/base"
require "nokogiri/xml/schematron/namespace"
require "nokogiri/xml/schematron/paragraph"
require "nokogiri/xml/schematron/pattern"

module Nokogiri
  module XML
    module Schematron
      # The internal representation of the +<sch:schema>+ XML element.
      #
      # For example:
      #
      #   schema = Nokogiri::XML::Schematron::Schema.new(id: "schema1", title: "Example schema")
      #   # => #<Nokogiri::XML::Schematron::Schema:0x00007fa1fb9e3b68 @parent=nil, @children=[], @options={:id=>"schema1", :title=>"Example schema"}>
      #   schema.to_builder.to_xml
      #   # => "<?xml version=\"1.0\"?>\n<sch:schema xmlns:sch=\"http://purl.oclc.org/dsdl/schematron\" id=\"schema1\" title=\"Example schema\"/>\n"
      #
      class Schema < Nokogiri::XML::Schematron::Base
        # @!attribute [rw] id
        #   @return [String] the value of the +@id+ XML attribute.
        attribute :id

        # @!attribute [rw] title
        #   @return [String] the value of the +@title+ XML attribute.
        attribute :title

        # @!method ns(**options, &block)
        #   Create a new +Namespace+ object.
        #   @param options [Hash<Symbol, Object>] the options.
        #   @option options [String] :prefix the value of the +@prefix+ XML attribute.
        #   @option options [String] :uri the value of the +@uri+ XML attribute.
        #   @yieldparam ns [Nokogiri::XML::Schematron::Namespace] the internal representation of the +<sch:ns>+ XML element.
        #   @yieldreturn [void]
        #   @return [Nokogiri::XML::Schematron::Namespace] the +Namespace+ object.
        element :ns, Nokogiri::XML::Schematron::Namespace

        # @!method p(**options, &block)
        #   Create a new +Paragraph+ object.
        #   @param options [Hash<Symbol, Object>] the options.
        #   @option options [String] :message the text content of the +<sch:p>+ XML element.
        #   @yieldparam p [Nokogiri::XML::Schematron::Paragraph] the internal representation of the +<sch:p>+ XML element.
        #   @yieldreturn [void]
        #   @return [Nokogiri::XML::Schematron::Paragraph] the +Paragraph+ object.
        element :p, Nokogiri::XML::Schematron::Paragraph

        # @!method pattern(**options, &block)
        #   Create a new +Pattern+ object.
        #   @param options [Hash<Symbol, Object>] the options.
        #   @option options [String] :id the value of the +@id+ XML attribute.
        #   @option options [String] :name the value of the +@name+ XML attribute.
        #   @yieldparam pattern [Nokogiri::XML::Schematron::Pattern] the internal representation of the +<sch:pattern>+ XML element.
        #   @yieldreturn [void]
        #   @return [Nokogiri::XML::Schematron::Pattern] the +Pattern+ object.
        element :pattern, Nokogiri::XML::Schematron::Pattern

        # Create a new +Schema+ object.
        #
        # @param options [Hash<Symbol, Object>] the options.
        # @option options [#to_s] :id the value of the +@id+ XML attribute.
        # @option options [#to_s] :title the value of the +@title+ XML attribute.
        # @yieldparam schema [Nokogiri::XML::Schematron::Schema] the internal representation of the +<sch:schema>+ XML element.
        # @yieldreturn [void]
        def initialize(**options, &block)
          super(nil, **options, &block)
        end

        protected

        def build!(xml)
          xml["sch"].send(:schema, %w(id title).inject(xmlns) { |acc, method_name|
            unless (s = send(method_name.to_sym)).nil?
              acc[method_name.to_s] = s
            end

            acc
          }) do
            super(xml)
          end

          return
        end
      end
    end
  end
end
