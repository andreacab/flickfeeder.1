class RenameLabelsMedia < ActiveRecord::Migration
    def self.up
        rename_table :labels_media, :labels_medias
    end
    def self.down
        rename_table :labels_medias, :labels_media
    end
end
