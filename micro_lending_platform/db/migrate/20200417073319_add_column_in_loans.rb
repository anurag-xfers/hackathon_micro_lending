class AddColumnInLoans < ActiveRecord::Migration
  def change
    add_column :loans, :requester_id, :integer
  end
end
