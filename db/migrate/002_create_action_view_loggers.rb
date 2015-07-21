class CreateActionViewLoggers < ActiveRecord::Migration
  def up
    create_table :action_view_loggers, :options => 'DEFAULT CHARSET=utf8' do |t|
      t.string   :transaction_id
      t.text     :payload
      t.datetime :start_time
      t.datetime :end_time
      t.float    :duration
      t.index    :transaction_id
    end
    #add_index :action_view_loggers, [:transaction_id]
  end

  def down
    drop_table :action_view_loggers
  end
end


 
