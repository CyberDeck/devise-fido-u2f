class Create<%= table_name.camelize %> < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :<%= table_name %> do |t|
      t.references  :user,                  null: false, polymorphic: true, index: true
      t.string      :name,                  null: false, default: ""
      t.string      :key_handle,            null: false, limit: 255, default: ""
      t.binary      :public_key,            null: false, limit: 10.kilobytes, default: ""
      t.binary      :certificate,           null: false, limit: 1.megabyte, default: ""
      t.integer     :counter,               null: false, default: 0
      t.timestamp   :last_authenticated_at, null: false
<% attributes.each do |attribute| -%> 
      t.<%= attribute.type %> :<%= attribute.name %>
<% end -%>
      t.timestamps
    end
    add_index :<%= table_name %>, :key_handle
    add_index :<%= table_name %>, :last_authenticated_at
  end
end
