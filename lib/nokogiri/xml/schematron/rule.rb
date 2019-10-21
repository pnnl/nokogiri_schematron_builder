require "nokogiri/xml/schematron/assertion"
require "nokogiri/xml/schematron/base"

module Nokogiri
  module XML
    module Schematron
      # The internal representation of the +<sch:rule>+ XML element.
      #
      # For example:
      #
      #   rule = Nokogiri::XML::Schematron::Rule.new(nil, id: "rule1", context: "//ex:Example")
      #   # => #<Nokogiri::XML::Schematron::Rule:0x00007fa1fb9e8410 @parent=nil, @children=[], @options={:id=>"rule1", :context=>"//ex:Example"}>
      #   rule.to_builder.to_xml
      #   # => "<?xml version=\"1.0\"?>\n<sch:rule xmlns:sch=\"http://purl.oclc.org/dsdl/schematron\" id=\"rule1\" context=\"//ex:Example\"/>\n"
      #
      class Rule < Nokogiri::XML::Schematron::Base
        # @!attribute [rw] context
        #   @return [String] the value of the +@context+ XML attribute.
        attribute :context

        # @!attribute [rw] id
        #   @return [String] the value of the +@id+ XML attribute.
        attribute :id

        # @!method assert(**options, &block)
        #   Create a new +Assertion+ object.
        #   @param options [Hash<Symbol, Object>] the options.
        #   @option options [String] :message the text content of the +<sch:assert>+ XML element.
        #   @option options [String] :test the value of the +@test+ XML attribute.
        #   @yieldparam assert [Nokogiri::XML::Schematron::Assertion] the internal representation of the +<sch:assert>+ XML element.
        #   @yieldreturn [void]
        #   @return [Nokogiri::XML::Schematron::Assertion] the +Assertion+ object.
        element :assert, Nokogiri::XML::Schematron::Assertion

        protected

        def build!(xml)
          xml["sch"].send(:rule, %w(id context).inject(xmlns) { |acc, method_name|
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
