class Foo < ActiveRecord::Base

  include Summarizer::Base

  summarize :price, :costs, :diff

  belongs_to :bar

  def diff
    self.price - self.costs
  end

end


class CreateFoos < ActiveRecord::Migration
  def self.up
    create_table :foos do |t|
      t.string :name
      t.datetime :at
      t.integer :bar_id
      t.decimal :price,      :precision => 12, :scale => 2
      t.decimal :costs,      :precision => 12, :scale => 2
      t.timestamps
    end
  end

  def self.down
    drop_table :foos
  end
end

