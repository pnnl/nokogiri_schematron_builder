require "nokogiri/xml/schematron/base"

module Nokogiri
  module XML
    module Schematron
      module Nodes
        # The base class for internal representations of abstract syntax tree
        # (AST) nodes, where the tree is denested and then used to build a
        # sequence of zero or more +<sch:rule>+ elements.
        # @abstract
        class Base < Nokogiri::XML::Schematron::Base
          # @return [Hash<String, Nokogiri::XML::Schematron::Nodes::Base>] the hash of child nodes by XPaths.
          attr_reader :child_node_by_context

          # @return [String] the XPath.
          attr_accessor :context

          # Create a new +Nodes::Base+ object.
          #
          # @param parent [Nokogiri::XML::Schematron::Base] the parent object.
          # @param context [String] the XPath.
          # @param options [Hash<Symbol, Object>] the options.
          # @yieldparam node [Nokogiri::XML::Schematron::Nodes::Base] the +Nodes::Base+ object.
          # @yieldreturn [void]
          # @raise [ArgumentError] if the XPath is +nil+.
          def initialize(parent, context, **options, &block)
            @child_node_by_context = {}

            if context.nil?
              raise ::ArgumentError
            else
              @context = context
            end

            super(parent, **options, &block)
          end

          # Create a new +Nodes::Permit+ object.
          #
          # @param context [String] the XPath.
          # @param options [Hash<Symbol, Object>] the options.
          # @yieldparam node [Nokogiri::XML::Schematron::Nodes::Permit] the +Nodes::Permit+ object.
          # @yieldreturn [void]
          # @return [Nokogiri::XML::Schematron::Nodes::Permit] the +Nodes::Permit+ object.
          # @raise [ArgumentError] if the XPath is +nil+.
          def permit(context, **options, &block)
            node = Nokogiri::XML::Schematron::Nodes::Permit.new(self, context, **options, &block)
            @child_node_by_context[context] = node
            node
          end

          # Create a new +Nodes::Reject+ object.
          #
          # @param context [String] the XPath.
          # @param options [Hash<Symbol, Object>] the options.
          # @yieldparam node [Nokogiri::XML::Schematron::Nodes::Reject] the +Nodes::Reject+ object.
          # @yieldreturn [void]
          # @return [Nokogiri::XML::Schematron::Nodes::Reject] the +Nodes::Reject+ object.
          # @raise [ArgumentError] if the XPath is +nil+.
          def reject(context, **options, &block)
            node = Nokogiri::XML::Schematron::Nodes::Reject.new(self, context, **options, &block)
            @child_node_by_context[context] = node
            node
          end

          # Create a new +Nodes::Require+ object.
          #
          # @param context [String] the XPath.
          # @param options [Hash<Symbol, Object>] the options.
          # @yieldparam node [Nokogiri::XML::Schematron::Nodes::Require] the +Nodes::Require+ object.
          # @yieldreturn [void]
          # @return [Nokogiri::XML::Schematron::Nodes::Require] the +Nodes::Require+ object.
          # @raise [ArgumentError] if the XPath is +nil+.
          def require(context, **options, &block)
            node = Nokogiri::XML::Schematron::Nodes::Require.new(self, context, **options, &block)
            @child_node_by_context[context] = node
            node
          end

          # Create a new +Nodes::Validations::Exclusion+ object.
          #
          # @param context [String] the XPath.
          # @param options [Hash<Symbol, Object>] the options.
          # @option options [Array<String>] :in ([]) the array of available items.
          # @yieldparam node [Nokogiri::XML::Schematron::Nodes::Validations::Exclusion] the +Nodes::Validations::Exclusion+ object.
          # @yieldreturn [void]
          # @return [Nokogiri::XML::Schematron::Nodes::Validations::Exclusion] the +Nodes::Validations::Exclusion+ object.
          def validates_exclusion_of(context, **options, &block)
            node = Nokogiri::XML::Schematron::Nodes::Validations::Exclusion.new(self, context, **options, &block)
            @child_node_by_context[context] = node
            node
          end

          # Create a new +Nodes::Validations::Inclusion+ object.
          #
          # @param context [String] the XPath.
          # @param options [Hash<Symbol, Object>] the options.
          # @option options [Array<String>] :in ([]) the array of available items.
          # @yieldparam node [Nokogiri::XML::Schematron::Nodes::Validations::Inclusion] the +Nodes::Validations::Inclusion+ object.
          # @yieldreturn [void]
          # @return [Nokogiri::XML::Schematron::Nodes::Validations::Inclusion] the +Nodes::Validations::Inclusion+ object.
          def validates_inclusion_of(context, **options, &block)
            node = Nokogiri::XML::Schematron::Nodes::Validations::Inclusion.new(self, context, **options, &block)
            @child_node_by_context[context] = node
            node
          end

          # Create a new +Nodes::Validations::Numericality+ object.
          #
          # @param context [String] the XPath.
          # @param options [Hash<Symbol, Object>] the options.
          # @option options [Boolean] :even (false) Specifies the value must be an even number.
          # @option options [Integer, Float] :equal_to (nil) Specifies the value must be equal to the supplied value.
          # @option options [Integer, Float] :greater_than (nil) Specifies the value must be greater than the supplied value.
          # @option options [Integer, Float] :greater_than_or_equal_to (nil) Specifies the value must be greater than or equal the supplied value.
          # @option options [Integer, Float] :less_than (nil) Specifies the value must be less than the supplied value.
          # @option options [Integer, Float] :less_than_or_equal_to (nil) Specifies the value must be less than or equal the supplied value.
          # @option options [Boolean] :odd (false) Specifies the value must be an odd number.
          # @option options [Integer, Float] :other_than (nil) Specifies the value must be other than the supplied value.
          # @yieldparam node [Nokogiri::XML::Schematron::Nodes::Validations::Numericality] the +Nodes::Validations::Numericality+ object.
          # @yieldreturn [void]
          # @return [Nokogiri::XML::Schematron::Nodes::Validations::Numericality] the +Nodes::Validations::Numericality+ object.
          def validates_numericality_of(context, **options, &block)
            node = Nokogiri::XML::Schematron::Nodes::Validations::Numericality.new(self, context, **options, &block)
            @child_node_by_context[context] = node
            node
          end

          protected

          def build!(xml)
            if @child_node_by_context.any?
              xml["sch"].send(:rule, xmlns.merge({
                "context" => send(:absolute_context),
              })) do
                @child_node_by_context.each_pair.sort_by { |pair| pair[0] }.each do |pair|
                  pair[1].send(:build_assertion!, xml)
                end

                super(xml)
              end

              @child_node_by_context.each_pair.sort_by { |pair| pair[0] }.each do |pair|
                pair[1].send(:build!, xml)
              end
            end

            return
          end

          # Build the XML representation of the +<sch:assert>+ XML element.
          #
          # @param xml [Nokogiri::XML::Builder] the XML builder.
          # @return [void]
          def build_assertion!(xml)
            return
          end

          private

          # @return [String] the absolute XPath with respect to the abstract syntax tree.
          def absolute_context
            return @context unless @parent.is_a?(Nokogiri::XML::Schematron::Nodes::Base)

            prefix = @parent.send(:absolute_context)

            separator = \
              case prefix
                when "/" then ""
                else "/"
              end

            [
              prefix,
              @context,
            ].join(separator)
          end
        end
      end
    end
  end
end

require "nokogiri/xml/schematron/nodes/permit"
require "nokogiri/xml/schematron/nodes/reject"
require "nokogiri/xml/schematron/nodes/require"
require "nokogiri/xml/schematron/nodes/validations/exclusion"
require "nokogiri/xml/schematron/nodes/validations/inclusion"
require "nokogiri/xml/schematron/nodes/validations/numericality"
