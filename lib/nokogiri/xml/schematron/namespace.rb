require "nokogiri/xml/schematron/base"

module Nokogiri
  module XML
    module Schematron
      # The internal representation of the +<sch:ns>+ XML element.
      #
      # For example:
      #
      #   namespace = Nokogiri::XML::Schematron::Namespace.new(nil, prefix: "ex", uri: "http://example.com/ns#")
      #   # => #<Nokogiri::XML::Schematron::Namespace:0x00007f8486acd4f8 @parent=nil, @children=[], @options={:prefix=>"ex", :uri=>"http://example.com/ns#"}>
      #   namespace.to_builder.to_xml
      #   # => "<?xml version=\"1.0\"?>\n<sch:ns xmlns:sch=\"http://purl.oclc.org/dsdl/schematron\" prefix=\"ex\" uri=\"http://example.com/ns#\"/>\n"
      #
      class Namespace < Nokogiri::XML::Schematron::Base
        # @!attribute [rw] prefix
        #   @return [String] the value of the +@prefix+ XML attribute.
        attribute :prefix

        # @!attribute [rw] uri
        #   @return [String] the value of the +@uri+ XML attribute.
        attribute :uri

        protected

        def build!(xml)
          xml["sch"].send(:ns, %w(prefix uri).inject(xmlns) { |acc, method_name|
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
