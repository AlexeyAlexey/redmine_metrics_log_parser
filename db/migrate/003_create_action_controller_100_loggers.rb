class CreateActionController100Loggers < ActiveRecord::Migration
  def up
    create_table :action_controller_100_loggers do |t|
      t.string   :transaction_id
      t.string   :current_user,  default: ""   
      t.string   :controller
      t.string   :action
      t.integer  :status,       limit: 2, default: 0
      t.text     :payload
      t.datetime :start_time
      t.datetime :end_time
      t.column   :view_runtime, 'FLOAT UNSIGNED'
      t.column   :db_runtime,   'FLOAT UNSIGNED'
      t.column   :duration,     'FLOAT UNSIGNED'
    end
    add_index :action_controller_100_loggers, [:transaction_id]    
  end

  def down
    drop_table :action_controller_100_loggers
  end
end
