require "nokogiri/xml/schematron/base"

module Nokogiri
  module XML
    module Schematron
      # The internal representation of the +<sch:p>+ XML element.
      #
      # For example:
      #
      #   paragraph = Nokogiri::XML::Schematron::Paragraph.new(nil, message: "Hello, world!")
      #   # => #<Nokogiri::XML::Schematron::Paragraph:0x00007f848783e628 @parent=nil, @children=[], @options={:message=>"Hello, world!"}>
      #   paragraph.to_builder.to_xml
      #   # => "<?xml version=\"1.0\"?>\n<sch:p xmlns:sch=\"http://purl.oclc.org/dsdl/schematron\">Hello, world!</sch:p>\n"
      #
      class Paragraph < Nokogiri::XML::Schematron::Base
        # @!attribute [rw] message
        #   @return [String] the text content of the +<sch:p>+ XML element.
        attribute :message

        protected

        def build!(xml)
          xml["sch"].send(:p, xmlns) do
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
