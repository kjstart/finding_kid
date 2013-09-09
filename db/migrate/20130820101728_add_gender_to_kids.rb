class AddGenderToKids < ActiveRecord::Migration
  def change
    add_column :kids, :gender, :string
  end
end
