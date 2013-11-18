class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :name
      t.string :slug
      t.text :data
      t.timestamps
    end

    add_index :artists, :slug
  end
end
