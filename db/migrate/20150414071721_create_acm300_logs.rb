class CreateAcm300Logs < ActiveRecord::Migration
  def change
    create_table :acm300_logs do |t|
      t.string :acm_module
      t.date :log_date
      t.datetime :log_time
      t.float :vin
      t.float :iin
      t.float :vout
      t.float :iout
      t.float :power

      t.timestamps null: false
    end
  end
end
