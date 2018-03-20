require 'erb'

module Opstat
module Plugins
class OracleSessions < Task

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
               column dummy noprint
               column  used    format 999999999999   heading \"Used\"
               column  free   format  999999999999  heading \"Free\"

               SELECT
                 (SELECT COUNT(*) FROM V\\\$SESSION) as used,
                 (VP\.VALUE - (select count(*) from v\\\$Session)) as free
               FROM 
                 V\\\$PARAMETER VP
               WHERE VP\.NAME = '"'sessions'"';
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
#need:
#access to v_$parameter
#access to v_$session
