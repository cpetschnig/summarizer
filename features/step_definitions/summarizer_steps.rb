Given /^I need sub\-totals for each month,$/ do
  @order_by = 'at ASC'
  @split_sections_on =Proc.new {|a,b| a.at.month != b.at.month}
  @section_label = Proc.new{|obj| obj.at.strftime("%B %Y")}
  #srand(Time.new.nsec)
  50.times { Factory.create :foo }
end

When /^I call `Foo::find_with_sums`$/ do
  @foos = Foo.find_with_sums(:all,
    :order => @order_by, :split_sections_on => @split_sections_on,
    :section_label => @section_label)
end

When /^I use `each_with_sums`$/ do
  @foos.each_with_sums do |item|
    
  end
end

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