#--
# Copyright (c) 2009 Christoph Petschnig
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

# Adds a class to sum up attributes of the class where it's included
module Summarizer
  module Base
    def self.included(base)
      #  Class enhancements
      base.extend(ClassMethods)
    end

    class Summarizer

      def initialize(tied_to_class)
#p "Tied to class #{tied_to_class}"
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
#p self.class.read_inheritable_attribute('tied_to_class')
#p obj.class
#        raise TypeError unless obj.class == self.class.read_inheritable_attribute('tied_to_class')
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

      def method_missing(symbol, *args)
        return @attributes[symbol] if @attributes.has_key? symbol
        super symbol, *args
      end

      def respond_to?(symbol, include_priv = false)
        return true if @attributes.has_key? symbol
        super symbol, include_priv
      end
    end

    # the methods in this module will become class methods
    module ClassMethods
      # macro: store the option and the attribute to summarize
      def summarize(attributes, options = {})
#p "#{self}#summarize"
        write_inheritable_attribute 'attributes', attributes
        write_inheritable_attribute 'options', options
      end

      def find_for_year_table(year, sort = 'at, descr')
        ar = self.find(:all, :conditions => ["YEAR(at) = ?", year], :order => sort)
        class << ar
          attr_reader :sum_year
          attr_writer :referring_class, :sorted_by_time
          # Displaying period headers and sums makes only sense, if we sort by date
          def sorted_by_time?
            @sorted_by_time
          end
          def each_for_year_table(&block)
            month = quarter = 0
            @sum_year = Summarizer.new(@referring_class)
            sum_month = Summarizer.new(@referring_class)
            sum_quarter = Summarizer.new(@referring_class)
            index = 0
            self.each do |item|
              class << item
#                attr_reader :new_month, :end_of_month, :sum_month, :new_quarter, :end_of_quarter, :sum_quarter
                def set_table_info(new_month, end_of_month, sum_month, new_quarter, end_of_quarter, sum_quarter)
                  @new_month = new_month
                  @end_of_month = end_of_month
                  @sum_month = sum_month if end_of_month
                  @new_quarter = new_quarter
                  @end_of_quarter = end_of_quarter
                  @sum_quarter = sum_quarter if end_of_quarter
                end
                # Returns +true+, if this items is the first of a new +:quarter+ or +:month+
                def new_period?(period)
                  period == :month ? @new_month : @new_quarter
                end
                # Returns +true+, if this items is the last of a +:quarter+ or +:month+
                def end_of_period?(period)
                  period == :month ? @end_of_month : @end_of_quarter
                end
                # Returns the summarizer object of the given period
                def period_sum(period)
                  period == :month ? @sum_month : @sum_quarter
                end
              end
              # check, if a new month or quarter begins
              new_month = item.month > month
              new_quarter = item.quarter > quarter
              # peek at the next item to see if item is the last of this month or quarter
              next_item = self.at(index + 1)
              end_of_month = next_item.nil? || next_item.month > item.month
              end_of_quarter = next_item.nil? || next_item.quarter > item.quarter
              # add it up!
              @sum_year.add(item)
              sum_month.add(item)
              sum_quarter.add(item)
              # store information in item
              item.set_table_info(new_month, end_of_month, sum_month, new_quarter, end_of_quarter, sum_quarter)
              # yield the block
              yield item
              # reset summarizer if neccesary
              sum_month.reset if end_of_month
              sum_quarter.reset if end_of_quarter
              # loop!
              month = item.month
              quarter = item.quarter
              index += 1
            end
            self
          end
        end
        ar.sorted_by_time = sort == 'at, descr'
        ar.referring_class = self    # ar just doesn't know otherwise, with class it belongs to
        ar
      end


    end

  end

end
