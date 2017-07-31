require 'erb'

module Opstat
module Plugins
class OracleTablespacesSizes < Task

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
               column  name    format a19     heading \\\"Tablespace Name\\\"
               column  bytes   format 999999999999    heading \"Total\"
               column  used    format 999999999999   heading \"Used\"
               column  free    format 999999999999  heading \"Free\"

               select nvl(b.tablespace_name, nvl(a.tablespace_name,'"'UNKOWN'"')) name,
                 bytes_alloc bytes,
                 bytes_alloc-nvl(bytes_free,0) used,
                 nvl(bytes_free,0) free
               from ( select sum(bytes) bytes_free,
                        tablespace_name
                      from  sys.dba_free_space
                      group by tablespace_name ) a,
                    ( select sum(bytes) bytes_alloc,
                        tablespace_name
                      from sys.dba_data_files
                      group by tablespace_name
                      union all
                      select sum(bytes) bytes_alloc,
                        tablespace_name
                      from sys.dba_temp_files
                      group by tablespace_name )b
                      where a.tablespace_name (+) = b.tablespace_name;
              "|sqlplus -S <%= @db_user %>/<%= @db_password %>' 
EOF
  end

  def parse
    report = []
    @cmd ||= sql_cmd.result(binding)
    oracle_output = IO.popen(@cmd)
    report  = oracle_output.readlines.join
    oracle_output.close
    oplogger.debug report
    return report
  end

end
end
end
