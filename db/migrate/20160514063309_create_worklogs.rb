class CreateWorklogs < ActiveRecord::Migration
  def change
    create_table :worklogs do |t|
      t.string :name
      t.string :user_key

      t.timestamps null: false
    end
  end
end
