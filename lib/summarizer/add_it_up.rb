# Adds a class to sum up attributes of the class where it's included
module Summarizer
  module Base
    class AddItUp

      def initialize(tied_to_class)
        # get options from referring class
        options = tied_to_class.read_inheritable_attribute 'options'
        # initialize attributes
        @attributes = {}
        (tied_to_class.read_inheritable_attribute('attributes') || []).each{|a| @attributes[a] = 0.0}
        @digits = options[:digits] || 2
        @digits_factor = 1.0
        @digits.times{ @digits_factor *= 10 }
        @empty = true
      end

      # Add attribute values of referring class instance
      def add(obj)
        @attributes.each{|key, value| @attributes[key] = value + (obj.send(key) * @digits_factor).round / @digits_factor}
        @empty = false
      end

      def reset
        @attributes.each_key{|key| @attributes[key] = 0.0}
        @empty = true
      end

      def empty?
        @empty
      end

      def static
        Static.new(@attributes)
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
