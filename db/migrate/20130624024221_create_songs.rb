class CreateSongs < ActiveRecord::Migration

  def change
    create_table :songs do |t|
      t.string :name
      t.references :album
      t.string :lyrics

      t.timestamps
    end
  end

end
