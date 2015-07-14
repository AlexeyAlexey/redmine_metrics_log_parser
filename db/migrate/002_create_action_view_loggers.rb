class CreateActionViewLoggers < ActiveRecord::Migration
  def change
    create_table :action_view_loggers do |t|
      t.string   :transaction_id
      t.text     :payload
      t.datetime :start_time
      t.datetime :end_time
      t.column   :duration, 'FLOAT UNSIGNED'
    end
    add_index :action_view_loggers, [:transaction_id]
  end

  def self.down
    drop_table :action_view_loggers
  end
end


 
