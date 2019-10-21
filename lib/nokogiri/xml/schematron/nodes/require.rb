require "nokogiri/xml/schematron/nodes/base"

module Nokogiri
  module XML
    module Schematron
      module Nodes
        # The abstract syntax tree node whose +@context+ XML attribute is REQUIRED.
        class Require < Nokogiri::XML::Schematron::Nodes::Base
          protected

          def build_assertion!(xml)
            xml["sch"].send(:assert, xmlns.merge({
              "test" => "count(#{@context}) >= 1",
            })) do
              xml.text("element \"#{@context}\" is REQUIRED")
            end

            return
          end
        end
      end
    end
  end
end
