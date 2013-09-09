class CreateKidComments < ActiveRecord::Migration
  def change
    create_table :kid_comments do |t|
      t.integer :kid_id
      t.integer :user_id
      t.string :comment

      t.timestamps
    end
  end
end
