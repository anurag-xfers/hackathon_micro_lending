class AddColumnsInUser < ActiveRecord::Migration
  def change
    add_column :users, :phone_number, :string
    add_column :users, :xfers_api_token, :string
  end
end
