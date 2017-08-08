require 'erb'

module Opstat
module Plugins
class OracleFrasSizes < Task

  def initialize (name, queue, config)
    super(name, queue, config)
    self
    @su_user = config['su_user']
    @db_user = config['db_user']
    @db_password = config['db_password']
  end

  def sql_cmd
    @query ||= ERB.new <<-EOF
su - <%= @su_user %> -c 'echo "     set pagesize 10000
               set heading on
               set linesize 150
               column dummy noprint
               column  name    format a60     heading \\\"Path\\\"
               column  space_limit   format 999999999999999    heading \"Total\"
               column  space_used    format 999999999999999   heading \"Used\"
               column  number_of_files    format 999999999999999  heading \"Files\"

               select name,
                 space_limit,
                 space_used,
                 number_of_files
               from v\\\$recovery_file_dest;
              "|sqlplus -S <%= @db_user %>/<%= @db_password %>' 
EOF
  end

  def parse
    report = []
    @cmd ||= sql_cmd.result(binding)
    oracle_output = IO.popen(@cmd)
    report  = oracle_output.readlines.join
    oracle_output.close
    return report
  end

end
end
end
#TODO check if it has privileges?
#grant select on v_$recovery_file_dest to nagios;
