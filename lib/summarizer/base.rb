# Adds a class to sum up attributes of the class where it's included
module Summarizer
  module Base

    def self.included(base)
      #  Class enhancements
      base.extend(ClassMethods)
    end

    # the methods in this module will become class methods
    module ClassMethods
      # macro: store the option and the attribute to summarize
      def summarize(*args)
        options = args.last.kind_of?(Hash) ? args.pop : {}

        write_inheritable_attribute 'attributes', args
        write_inheritable_attribute 'options', options
      end

      def find_with_sums(*args)

        options = args.extract_options!

        raise ArgumentError unless args.first.nil? || args.first == :all

        # extract method specific options before call to +find+
        split_sections_on = options.delete(:split_sections_on)
        section_label = options.delete(:section_label)

        ar = self.find(:all, options)

        class << ar
          attr_reader :total
          attr_writer :referring_class, :split_sections_on
          attr_accessor :section_label

          def each_with_sums(&block)

            @total = AddItUp.new(@referring_class)
            sub_total = AddItUp.new(@referring_class)
            previous_item = nil

            self.each_with_index do |item, index|
              class << item
                attr_writer :section_label
                def set_table_info(new_group, end_of_group, sum_group)
                  @new_section = new_group
                  @end_of_section = end_of_group
                  @sum_section = sum_group.static if end_of_group
                end
                # Returns +true+, if this items is the first of a new section
                def new_section?
                  @new_section
                end
                # Returns +true+, if this items is the last of a section
                def end_of_section?
                  @end_of_section
                end
                # Returns the summarizer object of the given section
                def section_sum
                  @sum_section
                end
                def section_label
                  if @section_label.kind_of?(Proc)
                    @section_label.call(self)
                  elsif @section_label.kind_of?(Symbol)
                    # if a Symbol is given, call the matching method
                    self.send(@section_label)
                  else
                    raise ArgumentError.new("@section_label has class #{@section_label.class}, but must be either Proc or Symbol.")
                    raise ArgumentError.new("Value of :section_label has class #{@section_label.class}, but must be either Proc or Symbol.")
                  end
                end
              end

              # check, if item opens a new section in the array
              new_section = previous_item.nil? || check_for_different_sections(previous_item, item)

              # peek at the next item to see if item is the last of the section
              next_item = self.at(index + 1)

              end_of_section = next_item.nil? || check_for_different_sections(item, next_item)

              # add it up!
              @total.add(item)
              sub_total.add(item)

              # store information in item
              item.set_table_info(new_section, end_of_section, sub_total)

              item.section_label = self.section_label

              # yield the block
              yield item

              # reset summarizer if neccesary
              sub_total.reset if end_of_section

              # loop!
              previous_item = item
            end

            self
          end

          private
          def check_for_different_sections(a, b)
            if @split_sections_on.kind_of?(Proc)
              # evaluate Proc to check, if item is in a new section
              @split_sections_on.call(a, b)
            elsif @split_sections_on.kind_of?(Symbol)
              # if a Symbol is given, compare the return values of their functions
              a.send(@split_sections_on) != b.send(@split_sections_on)
            else
              raise ArgumentError.new("Value of :split_sections_on has class #{@split_sections_on.class}, but must be either Proc or Symbol.")
            end
          end
        end

        ar.split_sections_on = split_sections_on
        ar.section_label = section_label

        # Array just wouldn't know otherwise, with class it belongs to
        ar.referring_class = self

        ar
      end

    end

  end
end