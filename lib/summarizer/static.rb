# Serves as a copy of AddItUp with static data
module Summarizer
  module Base
    class Static

      def initialize(attributes)
        @attributes = attributes.clone
      end

      def method_missing(symbol, *args)
        return @attributes[symbol] if @attributes.has_key? symbol
        super symbol, *args
      end

      def respond_to?(symbol, include_priv = false)
        return true if @attributes.has_key? symbol
        super symbol, include_priv
      end

    end
  end
end
