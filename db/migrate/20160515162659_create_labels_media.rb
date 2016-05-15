class CreateLabelsMedia < ActiveRecord::Migration
  def change
    create_table :labels_media do |t|
      t.belongs_to :label, index: true
      t.belongs_to :media, index: true
    end
  end
end
