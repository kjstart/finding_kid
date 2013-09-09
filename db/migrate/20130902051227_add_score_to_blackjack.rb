class AddScoreToBlackjack < ActiveRecord::Migration
  def change
    add_column :blackjacks, :holderscore, :integer
    add_column :blackjacks, :attenderscore, :integer
  end
end
