class AddActiverecordToArtists < ActiveRecord::Migration

  def up
    create_table :artists do |t|
      t.string :name, null: false
    end
  end

  def down
    drop_table :artists
  end

end
