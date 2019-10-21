require "nokogiri/xml/schematron/nodes/base"

module Nokogiri
  module XML
    module Schematron
      module Nodes
        # The abstract syntax tree node whose +@context+ XML attribute is the root.
        class Context < Nokogiri::XML::Schematron::Nodes::Base
        end
      end
    end
  end
end
