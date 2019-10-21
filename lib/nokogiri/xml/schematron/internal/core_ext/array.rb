module Nokogiri
  module XML
    module Schematron
      module Internal
        module CoreExt
          module Array
            # Converts the array to a comma-separated sentence where the last
            # element is joined by the connector word.
            #
            # @param array [Array<String>] the array of strings.
            # @param options [Hash<Symbol, Object>] the options.
            # @option options [String] :words_connector the sign or word used to join the elements in arrays with two or more elements.
            # @option options [String] :two_words_connector the sign or word used to join the elements in arrays with two elements.
            # @option options [String] :last_word_connector the sign or word used to join the last element in arrays with three or more elements.
            # @return [String] the comma-separated sentence.
            def self.to_sentence(array, options = {})
              case array.length
              when 0
                ''
              when 1
                array[0].to_s.dup
              when 2
                "#{array[0]}#{options[:two_words_connector]}#{array[1]}"
              else
                "#{array[0...-1].join(options[:words_connector])}#{options[:last_word_connector]}#{array[-1]}"
              end
            end
          end
        end
      end
    end
  end
end
