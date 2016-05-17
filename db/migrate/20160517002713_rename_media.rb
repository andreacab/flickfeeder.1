class RenameMedia < ActiveRecord::Migration
   def self.up
    rename_table :media, :medias
  end
  def self.down
    rename_table :medias, :media
  end
end
