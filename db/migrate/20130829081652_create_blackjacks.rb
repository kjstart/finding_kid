class CreateBlackjacks < ActiveRecord::Migration
  def change
    create_table :blackjacks do |t|
      t.integer :holder
      t.integer :attender
      t.string :holderpile
      t.string :attenderpile
      t.integer :winner

      t.timestamps
    end
  end
end
