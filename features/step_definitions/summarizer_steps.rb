Given /^I need sub\-totals for each month,$/ do
  @order_by = 'at DESC'
  @split_sections_on =Proc.new {|a,b| a.at.month != b.at.month}
  @section_label = Proc.new{|obj| obj.at.strftime("%B %Y")}
end

When /^I call `Foo::find_with_sums`$/ do
  @foos = Foo.find_with_sums(:all,
    :order => @order_by, :split_sections_on => @split_sections_on,
    :section_label => @section_label)
end

When /^I use `each_with_sums`$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see a table with sub\-totals$/ do
  pending # express the regexp above with the code you wish you had
end
