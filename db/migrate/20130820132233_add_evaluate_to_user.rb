class AddEvaluateToUser < ActiveRecord::Migration
  def change
    add_column :users, :credit, :integer
    add_column :users, :score, :integer
  end
end
