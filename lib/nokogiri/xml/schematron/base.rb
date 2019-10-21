require "nokogiri"

module Nokogiri
  module XML
    module Schematron
      # The base class for internal representations of Schematron types.
      # @abstract
      class Base
        class << self
          # Defines methods for a named XML attribute.
          #
          # For example:
          #
          #   attribute :name
          #
          # defines reader and writer methods that are equivalent to:
          #
          #   def name
          #     @options[:name]
          #   end
          #
          #   def name=(value)
          #     @options[:name] = value
          #   end
          #
          # @param name [#to_sym] the method name.
          # @param options [Hash<Symbol, Object>] the options.
          # @option options [Boolean] :reader (true) define the reader method?
          # @option options [Boolean] :writer (true) define the writer method?
          # @return [void]
          def attribute(name, **options)
            unless options[:reader] == false
              define_method(name.to_sym) do
                instance_variable_get(:@options).send(:[], name.to_sym)
              end
            end

            unless options[:writer] == false
              define_method(:"#{name.to_sym}=") do |value|
                instance_variable_get(:@options).send(:[]=, name.to_sym, value)
              end
            end

            return
          end

          # Defines methods for a named XML element.
          #
          # For example:
          #
          #   element :name, DescendentOfBase
          #
          # where
          #
          #   class DescendentOfBase < Base; end
          #
          # is a descendent of this class, defines methods that are equivalent to:
          #
          #   def name(*args, &block)
          #     base = DescendentOfBase.new(self, *args, &block)
          #     @children << base
          #     base
          #   end
          #
          # @param name [#to_sym] the method name.
          # @param klass [Class] the class.
          # @return [void]
          def element(name, klass)
            define_method(name.to_sym) do |*args, &block|
              base = klass.send(:new, self, *args, &block)
              instance_variable_get(:@children) << base
              base
            end
          end
        end

        # @return [Nokogiri::XML::Schematron::Base] the parent object.
        attr_reader :parent

        # @return [Array<Nokogiri::XML::Schematron::Base>] the children of the internal representation of the Schematron type.
        attr_reader :children

        # @return [Hash<Symbol, Object>] the options.
        attr_reader :options

        # Create a new +Base+ object.
        #
        # @param parent [Nokogiri::XML::Schematron::Base] the parent object.
        # @param options [Hash<Symbol, Object>] the options.
        # @yieldparam base [Nokogiri::XML::Schematron::Base] the internal representation of the Schematron type.
        # @yieldreturn [void]
        def initialize(parent, **options, &block)
          @parent = parent
          @children = []

          @options = options

          if block_given?
            case block.arity
              when 1 then block.call(self)
              else instance_eval(&block)
            end
          end
        end

        # Convert this +Base+ object to a +Builder+ object.
        #
        # @return [Nokogiri::XML::Builder]
        # @see https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Builder#initialize-instance_method
        def to_builder(*args)
          ::Nokogiri::XML::Builder.new(*args) do |xml|
            build!(xml)
          end
        end

        protected

        # Build the XML representation of the Schematron type.
        #
        # @param xml [Nokogiri::XML::Builder] the XML builder.
        # @return [void]
        def build!(xml)
          @children.each do |base|
            base.send(:build!, xml)
          end

          return
        end

        # @return [Hash<String, String>] the hash of XML namespaces (URI by prefix).
        def xmlns
          if @parent.nil?
            {
              "xmlns:sch" => "http://purl.oclc.org/dsdl/schematron",
            }
          else
            {}
          end
        end
      end
    end
  end
end
