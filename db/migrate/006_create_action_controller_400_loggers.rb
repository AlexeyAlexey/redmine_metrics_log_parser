class CreateActionController400Loggers < ActiveRecord::Migration
  def up
    create_table :action_controller_400_loggers, :options => 'DEFAULT CHARSET=utf8' do |t|
      t.string   :transaction_id
      t.string   :current_user,  default: ""   
      t.string   :controller
      t.string   :action
      t.integer  :status,       limit: 2, default: 0
      t.text     :payload
      t.datetime :start_time
      t.datetime :end_time
      t.float   :view_runtime
      t.float   :db_runtime
      t.float   :duration
    end
    add_index :action_controller_400_loggers, [:transaction_id]    
  end

  def down
    drop_table :action_controller_400_loggers
  end
end
