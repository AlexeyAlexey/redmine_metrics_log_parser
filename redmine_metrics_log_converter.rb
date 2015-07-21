require './boot'

ActiveRecord::Base.establish_connection(YAML::load(File.open('config/database.yml')))

module Convert
  def self.to_(str)
      begin
        # Parse
        sql = ""
        name = /=>name=(.*?)<=/.match(str)
        if name[1] == "process_action.action_controller"
          values = /=>name=(.*?)<==>transaction_id=(.*?)<==>current_user=(.*?)<==>controller=(.*?)<==>action=(.*?)<==>status=(.*?)<==>start_time=(.*?)<==>end_time=(.*?)<==>duration=(.*?)<==>view_runtime=(.*?)<==>db_runtime=(.*?)<==>payload=(.*?)<=/.match(str)
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

          transaction_id = values[2]
          current_user   = values[3]
          controller     = values[4]
          action         = values[5]
          status         = values[6].blank? ? 0 : values[6]
          start_time     = values[7]
          end_time       = values[8] 
          duration       = values[9]
          view_runtime   = values[10].blank? ? 0 : values[10]
          db_runtime     = values[11].blank? ? 0 : values[11]
          payload        = values[12]

          
        else
          values = /=>name=(.*?)<==>transaction_id=(.*?)<==>start_time=(.*?)<==>end_time=(.*?)<==>duration=(.*?)<==>payload=(.*?)<=/.match(str)
          
          transaction_id = values[2]
          start_time     = values[3]
          end_time       = values[4] 
          duration       = values[5] 
          payload        = values[6]
        end
        ActiveRecord::Base.connection.execute(sql) unless sql.empty?
      rescue Exception => e
         puts "#{e}"  
         #puts "#{e.backtrace.inspect}"
      end     
  end
end


begin
  file = File.open('action_controller_view_logger.log','r')
  while str_line = file.readline
    Convert::to_(str_line)
  end
rescue EOFError
  file.close
rescue Exception => e
  puts "#{e}" 
#retry
  
end

file.close




