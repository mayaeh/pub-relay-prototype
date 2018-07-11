class CreateBlocks < ActiveRecord::Migration[5.2]
  def change
    create_table :blocks do |t|
      t.string :domain, default: '', null: false, index: { unique: true }
    end
  end
end
