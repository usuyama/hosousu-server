require 'config'

ActiveRecord::Schema.define do
  create_table :users do |user|
    user.column :device_id, :string
    user.column :name, :string
    user.column :highscore, :integer
    user.column :rate, :integer
  end unless table_exists? :users
end
