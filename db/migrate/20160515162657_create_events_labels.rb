class CreateEventsLabels < ActiveRecord::Migration
  def change
    create_table :events_labels do |t|
      t.belongs_to :event, index: true
      t.belongs_to :label, index: true
    end
  end
end
