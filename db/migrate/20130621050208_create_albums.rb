class CreateAlbums < ActiveRecord::Migration

  def change
    create_table :albums do |t|
      t.string :name
      t.references :artist, index: true

      t.timestamps
    end
  end

end
