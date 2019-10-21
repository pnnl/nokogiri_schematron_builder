require "nokogiri/xml/schematron/internal/core_ext/array"
require "nokogiri/xml/schematron/nodes/base"

module Nokogiri
  module XML
    module Schematron
      module Nodes
        module Validations
          # The abstract syntax tree node that uses the +contains(haystack, needle)+
          # XPath function, where +haystack+ and +needle+ are strings, to test
          # if the +@context+ XML attribute is not included in an array of
          # available items.
          #
          # For the supplied array of available items
          #
          #   ["a", "b", "c"]
          #
          # and context
          #
          #   "/x/y/z/text()"
          #
          # this abstract syntax tree node is equivalent to the XPath:
          #
          #   "not(contains('_a_ _b_ _c_', concat('_', /x/y/z/text(), '_')))"
          #
          class Exclusion < Nokogiri::XML::Schematron::Nodes::Base
            # @!attribute [rw] in
            #   @return [Array<String>] the array of available items.
            attribute :in

            protected

            def build_assertion!(xml)
              xml["sch"].send(:assert, xmlns.merge({
                "test" => "not(contains('#{(send(:in) || []).collect { |s| "_#{s.gsub("'", "\\'")}_" }.join(" ")}', concat('_', #{@context}, '_')))",
              })) do
                xml.text("text \"")
                xml["sch"].send(:"value-of", {
                  "select" => @context,
                })
                xml.text("\": element \"#{@context}\" MUST NOT be #{Nokogiri::XML::Schematron::Internal::CoreExt::Array.to_sentence((send(:in) || []).collect { |s| "\"#{s.gsub("\"", "\\\"")}\"" }, last_word_connector: ", or ", two_words_connector: " or ", words_connector: ", ")}")
              end

              return
            end
          end
        end
      end
    end
  end
end
