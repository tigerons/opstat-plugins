module Opstat
module Plugins
class DockerNetwork < Task

  def initialize (name, queue, config)
    super(name, queue, config)
    @path = find_cgroup_path
    self
  end

  def find_container_pid(container_id)
    cmdIO = IO.popen("docker inspect -f '{{ .State.Pid }}' #{container_id}")
    container_pid = cmdIO.readlines.first.chomp
    cmdIO.close
    return container_pid
  end

  def find_running_containers
    cmdIO = IO.popen('docker ps --format "{{.ID}} {{.Image}} {{.Names}}" --no-trunc')
    output = cmdIO.readlines
    cmdIO.close
    docker_mappings = {}
    output.each do |container_line|
      container_line.match(/^(?<container_id>\S+)\s+(?<image>\S+)\s+(?<container_name>\S+)/)
      docker_mappings[$~[:container_id]] = { :image => $~[:image], :container_name => $~[:container_name] }
    end
    docker_mappings 
  end

  def parse
    @count_number += 1
    report = []
    find_running_containers.each do |container_id, properties|
      container_stats = { :container_id => container_id}.merge(properties)
      container_pid = find_container_pid(container_id)
      container_stats[:network] = File.open("/proc/#{container_pid}/net/dev").readlines
      report << container_stats
    end
    return report
  end
end
end
end

