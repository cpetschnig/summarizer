Given /^I need sub\-totals for each (.*)$/ do |sum_type|
  # get a symbol key out of string sum_type
  @sum_type = case sum_type
  when 'letter in the alphabet for `name`' then :name_1st_char
  else
    sum_type.gsub(/[- ]/, '_').to_sym
  end

  case @sum_type
  when :month then
    @order_by = 'at ASC'
    @proc = Proc.new{|obj| obj.at.strftime('%Y-%m')}
  when :name_1st_char then
    @order_by = 'name ASC'
    @proc = Proc.new{|obj| obj.name[0,1].upcase}
  when :different_bar then
    @order_by = 'bar_id ASC'
    @proc = Proc.new{|obj| obj.bar_id}
  else
    raise "Unknown test case `#{sum_type}`"
  end

  @split_sections_on = Proc.new {|a,b| @proc.call(a) != @proc.call(b)}

  #  create some data
  100.times { Factory.create :foo }

  @sum_comp = Hash.new

  foos = Foo.find(:all, :order => @order_by)
  foos.each do |foo|
    key = @proc.call(foo)

    #initialize pair
    @sum_comp[key] ||= {:costs => 0.0, :price => 0.0, :diff => 0.0}

    @sum_comp[key][:costs] += foo.costs
    @sum_comp[key][:price] += foo.price
    @sum_comp[key][:diff] += foo.diff
  end
  #@sum_comp.each{|k,v|puts "#{k}: #{v[:costs]} #{v[:price]} #{v[:diff]}"}
end

When /^I call `Foo::find_with_sums`$/ do
  @foos = Foo.find_with_sums(:all,
    :order => @order_by, :split_sections_on => @split_sections_on,
    :section_label => @proc)
end

Then /^`each_with_sums` should return correct values$/ do
  last_item = nil
  @foos.each_with_sums do |item|
    end_of_section = last_item && @proc.call(item) != @proc.call(last_item)

    key = @proc.call(last_item) if last_item

    if end_of_section
      last_item.section_sum.costs.should == @sum_comp[key][:costs]
      last_item.section_sum.price.should == @sum_comp[key][:price]
      last_item.section_sum.diff.should == @sum_comp[key][:diff]
    end
    
    last_item = item
  end
end

#When /^I use `each_with_sums`$/ do
#  @foos.each_with_sums do |item|
#
#
#  end
#end

Then /^I should see a table with sub\-totals$/ do
  @foos.each_with_sums do |item|
    puts "+--- #{item.section_label} ".ljust(60, '-') + '+' if item.new_section?
    puts "| #{item.at.strftime('%Y-%m-%d')}    #{item.name.ljust(8)} " +
      "#{(item.bar ? item.bar.name : '').rjust(8)} #{format('%.2f', item.costs).rjust(8)} " +
      "#{format('%.2f', item.price).rjust(8)} #{format('%.2f', item.diff).rjust(7)} |"
    if item.end_of_section?
      puts "+" + '-' * 59 + '+'
      puts "| Total #{item.section_label} ".ljust(34) + "#{format('%.2f', item.section_sum.costs).rjust(8)} " +
        "#{format('%.2f', item.section_sum.price).rjust(8)} #{format('%.2f', item.section_sum.diff).rjust(7)} |\n"
      puts "+" + '-' * 59 + "+\n\n"
    end
  end
  puts "+" + '-' * 59 + '+'
  puts "| Grand Total".ljust(34) + "#{format('%.2f', @foos.total.costs).rjust(8)} " +
    "#{format('%.2f', @foos.total.price).rjust(8)} #{format('%.2f', @foos.total.diff).rjust(7)} |\n"
  puts "+" + '-' * 59 + "+\n\n"
end