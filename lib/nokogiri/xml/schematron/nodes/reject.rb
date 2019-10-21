require "nokogiri/xml/schematron/nodes/base"

module Nokogiri
  module XML
    module Schematron
      module Nodes
        # The abstract syntax tree node whose +@context+ XML attribute is NOT RECOMMENDED.
        class Reject < Nokogiri::XML::Schematron::Nodes::Base
          protected

          def build_assertion!(xml)
            xml["sch"].send(:assert, xmlns.merge({
              "test" => "not(#{@context})",
            })) do
              xml.text("element \"#{@context}\" is NOT RECOMMENDED")
            end

            return
          end
        end
      end
    end
  end
end
