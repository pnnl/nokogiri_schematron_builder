require "nokogiri/xml/schematron/base"
require "nokogiri/xml/schematron/nodes/context"
require "nokogiri/xml/schematron/paragraph"
require "nokogiri/xml/schematron/rule"

module Nokogiri
  module XML
    module Schematron
      # The internal representation of the +<sch:pattern>+ XML element.
      #
      # For example:
      #
      #   pattern = Nokogiri::XML::Schematron::Pattern.new(nil, id: "pattern1", name: "Example pattern")
      #   # => #<Nokogiri::XML::Schematron::Pattern:0x00007f8486a71f18 @parent=nil, @children=[], @options={:id=>"pattern1", :name=>"Example pattern"}>
      #   pattern.to_builder.to_xml
      #   # => "<?xml version=\"1.0\"?>\n<sch:pattern xmlns:sch=\"http://purl.oclc.org/dsdl/schematron\" id=\"pattern1\" name=\"Example pattern\"/>\n"
      #
      class Pattern < Nokogiri::XML::Schematron::Base
        # @!attribute [rw] id
        #   @return [String] the value of the +@id+ XML attribute.
        attribute :id

        # @!attribute [rw] name
        #   @return [String] the value of the +@name+ XML attribute.
        attribute :name

        # @!method context(context, **options, &block)
        #   Create a new +Node::Context+ object.
        #   @example Denest an abstract syntax tree into a sequence of zero or more +<sch:rule>+ XML elements.
        #     # For example, the following...
        #     context("/") do
        #       require("ex:A") do
        #         permit("ex:B") do
        #           reject("ex:C")
        #         end
        #       end
        #     end
        #
        #     # ...is equivalent to:
        #     rule(context: "/") do
        #       assert(test: "count(ex:A) &gt;= 1", message: "element \"ex:A\" is REQUIRED")
        #     end
        #     rule(context: "/ex:A") do
        #       assert(test: "count(ex:B) &gt;= 0", message: "element \"ex:B\" is OPTIONAL")
        #     end
        #     rule(context: "/ex:A/ex:B") do
        #       assert(test: "not(ex:C)", message: "element \"ex:C\" is NOT RECOMMENDED")
        #     end
        #   @example Create business rules for the XML representation of a set of values.
        #     context("/") do
        #       require("ex:Example") do
        #         permit("ex:ExampleType") do
        #           validates_inclusion_of "text()", in: ["A", "B", "C"]
        #         end
        #       end
        #     end
        #   @example Create business rules for the XML representation of a set of values that is augmented with an "Other" value.
        #     context("/") do
        #       require("ex:Example") do
        #         permit("ex:ExampleType") do
        #           validates_inclusion_of "text()", in: ["A", "B", "C", "Other"]
        #         end
        #       end
        #       permit("ex:Example[ex:ExampleType and (ex:ExampleType/text() != 'Other')]") do
        #         reject("ex:OtherExampleType")
        #       end
        #       permit("ex:Example[ex:ExampleType and (ex:ExampleType/text() = 'Other')]") do
        #         require("ex:OtherExampleType")
        #       end
        #       permit("ex:Example[ex:OtherExampleType]") do
        #         require("ex:ExampleType") do
        #           validates_inclusion_of "text()", in: ["Other"]
        #         end
        #       end
        #     end
        #   @example Create business rules for the XML representation of a set of zero or more key-value pairs.
        #     context("/") do
        #       require("ex:KeyValuePairs") do
        #         permit("ex:KeyValuePair") do
        #           require("ex:Key") do
        #             validates_inclusion_of "text()", in: ["A", "B", "C"]
        #           end
        #           require("ex:Value")
        #         end
        #         permit("ex:KeyValuePair[ex:Key/text() = 'A']/ex:Value") do
        #           validates_inclusion_of "text()", in: ["a"]
        #         end
        #         permit("ex:KeyValuePair[ex:Key/text() = 'B']/ex:Value") do
        #           validates_inclusion_of "text()", in: ["b"]
        #         end
        #         permit("ex:KeyValuePair[ex:Key/text() = 'C']/ex:Value") do
        #           validates_inclusion_of "text()", in: ["c"]
        #         end
        #       end
        #     end
        #   @example Create business rules for an entity-relationship model.
        #     context("//ex:UserAccount") do
        #       require("@ID") do
        #         validates_numericality_of "text()", greater_than_or_equal_to: 1
        #       end
        #       permit("ex:Username") do
        #         validates_exclusion_of "text()", in: ["admin"]
        #       end
        #       reject("ex:Password")
        #     end
        #   @param context [String] the XPath.
        #   @param options [Hash<Symbol, Object>] the options.
        #   @yieldparam node [Nokogiri::XML::Schematron::Node::Context] the +Node::Context+ object.
        #   @yieldreturn [void]
        #   @return [Nokogiri::XML::Schematron::Node::Context] the +Node::Context+ object.
        element :context, Nokogiri::XML::Schematron::Nodes::Context

        # @!method p(**options, &block)
        #   Create a new +Paragraph+ object.
        #   @param options [Hash<Symbol, Object>] the options.
        #   @option options [String] :message the text content of the +<sch:p>+ XML element.
        #   @yieldparam p [Nokogiri::XML::Schematron::Paragraph] the internal representation of the +<sch:p>+ XML element.
        #   @yieldreturn [void]
        #   @return [Nokogiri::XML::Schematron::Paragraph] the +Paragraph+ object.
        element :p, Nokogiri::XML::Schematron::Paragraph

        # @!method rule(**options, &block)
        #   Create a new +Rule+ object.
        #   @param options [Hash<Symbol, Object>] the options.
        #   @option options [String] :context the value of the +@context+ XML attribute.
        #   @option options [String] :id the value of the +@id+ XML attribute.
        #   @yieldparam rule [Nokogiri::XML::Schematron::Rule] the internal representation of the +<sch:rule>+ XML element.
        #   @yieldreturn [void]
        #   @return [Nokogiri::XML::Schematron::Rule] the +Rule+ object.
        element :rule, Nokogiri::XML::Schematron::Rule

        protected

        def build!(xml)
          xml["sch"].send(:pattern, %w(id name).inject(xmlns) { |acc, method_name|
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
