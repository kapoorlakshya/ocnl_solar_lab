class AddTempBpstToFluke < ActiveRecord::Migration
  def change
    add_column :flukes, :temp_bpst, :string
  end
end
