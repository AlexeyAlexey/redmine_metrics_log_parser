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
      status = 0
      case (values[6] || 0).to_i
      when 100..199
        status = 100
      when 200..299
        status = 200
      when 300..399
        status = 300
      when 400..499
        status = 400
      when 500..599
        status = 500
      else
        status = 0
      end
       
      sql = "INSERT INTO action_controller_#{status}_loggers (transaction_id,
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
                                                         '#{values[6].blank? ? 0 : values[6]}', 
                                                         '#{values[7]}',
                                                         '#{values[8]}', 
                                                         '#{values[9]}', 
                                                         '#{values[10].blank? ? 0 : values[10]}', 
                                                         '#{values[11]}', 
                                                         '#{ActiveRecord::Base.connection.quote_string(values[12])}' );"
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
                                                  '#{ActiveRecord::Base.connection.quote_string(values[6])}' );"
    end
    ActiveRecord::Base.connection.execute(sql) unless sql.empty?
    
  rescue Exception => e
     #puts "#{e}"	
     #puts "#{e.backtrace.inspect}"
  end     
end

