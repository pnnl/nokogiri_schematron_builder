require "nokogiri/xml/schematron/base"

module Nokogiri
  module XML
    module Schematron
      # The internal representation of the +<sch:assert>+ XML element.
      #
      # For example:
      #
      #   assertion = Nokogiri::XML::Schematron::Assertion.new(nil, test: "not(ex:Example)", message: "element \"ex:Example\" is NOT RECOMMENDED")
      #   # => #<Nokogiri::XML::Schematron::Assertion:0x00007fa739a55dd8 @parent=nil, @children=[], @options={:test=>"not(ex:Example)", :message=>"element \"ex:Example\" is NOT RECOMMENDED"}>
      #   assertion.to_builder.to_xml
      #   # => "<?xml version=\"1.0\"?>\n<sch:assert xmlns:sch=\"http://purl.oclc.org/dsdl/schematron\" test=\"not(ex:Example)\">element \"ex:Example\" is NOT RECOMMENDED</sch:assert>\n"
      #
      class Assertion < Nokogiri::XML::Schematron::Base
        # @!attribute [rw] message
        #   @return [String] the text content of the +<sch:assert>+ XML element.
        attribute :message

        # @!attribute [rw] test
        #   @return [String] the value of the +@test+ XML attribute.
        attribute :test

        protected

        def build!(xml)
          xml["sch"].send(:assert, %w(test).inject(xmlns) { |acc, method_name|
            unless (s = send(method_name.to_sym)).nil?
              acc[method_name.to_s] = s
            end

            acc
          }) do
            unless (s = send(:message)).nil?
              xml.text(s)
            end

            super(xml)
          end

          return
        end
      end
    end
  end
end
