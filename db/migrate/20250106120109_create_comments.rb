class CreateComments < ActiveRecord::Migration[7.2]
  def change
        create_table :comments do |t|
      t.text :content
      t.integer :post_id      

      t.timestamps
    end
  end
end
