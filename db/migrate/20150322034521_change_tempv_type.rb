class ChangeTempvType < ActiveRecord::Migration
  def change
    change_column :flukes, :irr_py1, :string
    change_column :flukes, :irr_py2, :string
    change_column :flukes, :temp_rc1, :string
    change_column :flukes, :temp_rc2, :string
    change_column :flukes, :irr_rc1, :string
    change_column :flukes, :irr_rc2, :string
    change_column :flukes, :temp_pv1, :string
    change_column :flukes, :temp_pv2, :string
    change_column :flukes, :temp_pv3, :string
    change_column :flukes, :temp_pv4, :string
    change_column :flukes, :temp_pv5, :string
    change_column :flukes, :temp_pv6, :string
    change_column :flukes, :temp_hxi, :string
    change_column :flukes, :temp_hxo, :string
    change_column :flukes, :temp_amb, :string
    change_column :flukes, :temp_bbox, :string
    change_column :flukes, :temp_wtt, :string
    change_column :flukes, :temp_wtb, :string
  end
end
