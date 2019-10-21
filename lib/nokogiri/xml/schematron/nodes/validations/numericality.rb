require "nokogiri/xml/schematron/internal/core_ext/array"
require "nokogiri/xml/schematron/nodes/base"

module Nokogiri
  module XML
    module Schematron
      module Nodes
        module Validations
          # The abstract syntax tree node that uses the +number(any)+
          # XPath function, where +any+ is any value, to test if the +@context+
          # XML attribute is numeric.
          class Numericality < Nokogiri::XML::Schematron::Nodes::Base
            # @!attribute [rw] even
            #   @return [Boolean] the value must be an even number.
            attribute :even

            # @!attribute [rw] equal_to
            #   @return [Integer, Float] the value must be equal to the supplied value.
            attribute :equal_to

            # @!attribute [rw] greater_than
            #   @return [Integer, Float] the value must be greater than the supplied value.
            attribute :greater_than

            # @!attribute [rw] greater_than_or_equal_to
            #   @return [Integer, Float] the value must be greater than or equal the supplied value.
            attribute :greater_than_or_equal_to

            # @!attribute [rw] less_than
            #   @return [Integer, Float] the value must be less than the supplied value.
            attribute :less_than

            # @!attribute [rw] less_than_or_equal_to
            #   @return [Integer, Float] the value must be less than or equal the supplied value.
            attribute :less_than_or_equal_to

            # @!attribute [rw] odd
            #   @return [Boolean] the value must be an odd number.
            attribute :odd

            # @!attribute [rw] other_than
            #   @return [Integer, Float] the value must be other than the supplied value.
            attribute :other_than

            protected

            def build_assertion!(xml)
              tests = [
                "number(#{@context}) = #{@context}",
              ]

              messages = [
                "MUST be a number",
              ]

              PROC_BY_METHOD_NAME.each do |method_name, block|
                unless (orig_value = send(method_name.to_sym)).nil? || (pair = block.call(orig_value)).nil?
                  tests << pair[0]
                  messages << pair[1]
                end
              end

              xml["sch"].send(:assert, xmlns.merge({
                "test" => tests.collect { |s| "(#{s})" }.join(" and "),
              })) do
                xml.text("text \"")
                xml["sch"].send(:"value-of", {
                  "select" => @context,
                })
                xml.text("\": element \"#{@context}\" #{Nokogiri::XML::Schematron::Internal::CoreExt::Array.to_sentence(messages, last_word_connector: ", and ", two_words_connector: " and ", words_connector: ", ")}")
              end

              return
            end

            private

            # @return [Hash<Symbol, Proc>] the hash of blocks by method name.
            PROC_BY_METHOD_NAME = {
              even: ::Proc.new { |bool|
                if bool == true
                  [
                    "number(#{@context}) mod 2 = 0",
                    "MUST be even",
                  ]
                else
                  nil
                end
              },
              equal_to: ::Proc.new { |number|
                [
                  "number(#{@context}) = #{number}",
                  "MUST be equal to #{number}",
                ]
              },
              greater_than: ::Proc.new { |number|
                [
                  "number(#{@context}) > #{number}",
                  "MUST be greater than #{number}",
                ]
              },
              greater_than_or_equal_to: ::Proc.new { |number|
                [
                  "number(#{@context}) >= #{number}",
                  "MUST be greater than or equal to #{number}",
                ]
              },
              less_than: ::Proc.new { |number|
                [
                  "number(#{@context}) < #{number}",
                  "MUST be less than #{number}",
                ]
              },
              less_than_or_equal_to: ::Proc.new { |number|
                [
                  "number(#{@context}) <= #{number}",
                  "MUST be less than or equal to #{number}",
                ]
              },
              odd: ::Proc.new { |bool|
                if bool == true
                  [
                    "number(#{@context}) mod 2 = 1",
                    "MUST be odd",
                  ]
                else
                  nil
                end
              },
              other_than: ::Proc.new { |number|
                [
                  "number(#{@context}) != #{number}",
                  "MUST NOT be equal to #{number}",
                ]
              },
            }
          end
        end
      end
    end
  end
end
