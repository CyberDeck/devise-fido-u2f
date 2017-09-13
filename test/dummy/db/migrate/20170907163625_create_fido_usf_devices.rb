class CreateFidoUsfDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :fido_usf_devices do |t|
      t.references  :user,                  null: false, polymorphic: true, index: true
      t.string      :name,                  null: false, default: ""
      t.string      :key_handle,            null: false, limit: 255, default: ""
      t.binary      :public_key,            null: false, limit: 10.kilobytes, default: ""
      t.binary      :certificate,           null: false, limit: 1.megabyte, default: ""
      t.integer     :counter,               null: false, default: 0
      t.timestamp   :last_authenticated_at, null: false
      t.timestamps
    end
    add_index :fido_usf_devices, :key_handle
    add_index :fido_usf_devices, :last_authenticated_at
  end
end
