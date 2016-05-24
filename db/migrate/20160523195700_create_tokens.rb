class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :token
      t.references :user, index: true
      t.timestamps
    end
  end
end
