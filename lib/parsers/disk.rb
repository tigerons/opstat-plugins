require 'yaml'

# TODO connect client settings with master (version, etc)
# df --output='source,fstype,used,avail,itotal,iused,iavail,target'
module Opstat
module Parsers
  FS_TYPES = ["ext2", "ext3", "ext4", "reiserfs", "xfs", "jfs"]
  class Disk
    include Opstat::Logging

    def parse_data(data)
      reports = []
      oplogger.debug data
      data.each do |line|
        stats = line.split
        if FS_TYPES.include?(stats[1])
          reports << {
            :device => stats[0],
	    :inode_total => stats[4].to_i,
            :inode_used => stats[5].to_i,
            :inode_free => stats[6].to_i,
	    :block_total => stats[2].to_i + stats[3].to_i,
            :block_used => stats[2].to_i,
            :block_free => stats[3].to_i,
            :fstype => stats[1],
            :mount => stats[7]
          }
        end
      end
      return reports
    end
  end
end
end
