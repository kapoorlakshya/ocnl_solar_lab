class CreateFlukes < ActiveRecord::Migration
  def change
    create_table :flukes do |t|
      t.datetime :log_time
      t.integer :off
      t.string :irr_py1
      t.string :irr_py2
      t.float :irr_rc1
      t.float :temp_rc1
      t.float :irr_rc2
      t.float :temp_rc2
      t.string :flowrate
      t.float :temp_pv1
      t.float :temp_pv2
      t.float :temp_pv3
      t.float :temp_pv4
      t.float :temp_pv5
      t.float :temp_pv6
      t.float :temp_hxi
      t.float :temp_hxo
      t.float :temp_amb
      t.float :temp_bbox
      t.float :temp_wtt
      t.float :temp_wtb
      t.string :tempC
      t.float :total
      t.integer :dioalarm

      t.timestamps null: false
    end
  end
end
