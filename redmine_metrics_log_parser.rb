puts "hello"

require 'rubygems'  
require 'active_record'  
require 'byebug'

ActiveRecord::Base.establish_connection(  
  adapter:  "mysql2",
  database: "redmine_development",
  host:     "localhost",
  username: "redmine",
  password: "",
  encoding: "utf8"    
)  

while x = gets
  begin
  	# Parse
    sql = ""
    name = /=>name=(.*?)<=/.match(x)
    if name[1] == "process_action.action_controller"
      values = /=>name=(.*?)<==>transaction_id=(.*?)<==>current_user=(.*?)<==>controller=(.*?)<==>action=(.*?)<==>status=(.*?)<==>start_time=(.*?)<==>end_time=(.*?)<==>duration=(.*?)<==>view_runtime=(.*?)<==>db_runtime=(.*?)<==>payload=(.*?)<=/.match(x)
      
      sql = "INSERT INTO action_controller_loggers (transaction_id,
                                                    `current_user`,
                                                    controller,
                                                    action,
                                                    status,
                                                    start_time, 
                                                    end_time, 
                                                    duration, 
                                                    view_runtime,
                                                    db_runtime,
                                                    payload) 
                                                  VALUES('#{values[2]}',
                                                         '#{values[3]}',
                                                         '#{values[4]}',
                                                         '#{values[5]}', 
                                                         '#{values[6]}', 
                                                         '#{values[7]}',
                                                         '#{values[8]}', 
                                                         '#{values[9]}', 
                                                         '#{values[10]}', 
                                                         '#{values[11]}', 
                                                         '#{values[12]}' );"
    else
      values = /=>name=(.*?)<==>transaction_id=(.*?)<==>start_time=(.*?)<==>end_time=(.*?)<==>duration=(.*?)<==>payload=(.*?)<=/.match(x)
      sql = "INSERT INTO action_view_loggers (transaction_id, 
                                             start_time, 
                                             end_time, 
                                             duration, 
                                             payload)
                                           VALUES('#{values[2]}', 
                                                  '#{values[3]}', 
                                                  '#{values[4]}', 
                                                  '#{values[5]}', 
                                                  '#{values[6]}' );"
    end
    ActiveRecord::Base.connection.execute(sql) unless sql.empty?
    
  rescue Exception => e
     puts "#{e}"	
  end     
end

