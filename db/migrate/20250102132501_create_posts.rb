class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |p|
      p.text :author
      p.text :content

      p.timestamps
    end
  end
end
