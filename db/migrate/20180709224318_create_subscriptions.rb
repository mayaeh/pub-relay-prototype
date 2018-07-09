class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.string :account_id, null: false, default: '', index: { unique: true }
      t.string :inbox_url, null: false, default: ''
    end
  end
end
