class Bar < ActiveRecord::Base
  #data 'Alpha', 'Beta', 'Gamma', 'Omega'
end



class CreateBars < ActiveRecord::Migration
  def self.up
    create_table :bars do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :bars
  end
end

