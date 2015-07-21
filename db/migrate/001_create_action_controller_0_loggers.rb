class CreateActionController0Loggers < ActiveRecord::Migration
  def up
    create_table :action_controller_0_loggers, :options => 'DEFAULT CHARSET=utf8' do |t|
      t.string   :transaction_id
      t.string   :current_user,  default: "" 
      t.integer  :user_id  
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
  end

  def down
    drop_table :action_controller_0_loggers
  end
end
