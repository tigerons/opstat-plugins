module Opstat
module Plugins
class DockerBlkio < Task
  #TODO must have blkio.throttle.io_serviced and blkio.throttle.io_service_bytes files
  def initialize (name, queue, config)
    super(name, queue, config)
    @path = find_cgroup_path
    self
  end

  def find_cgroup_path
    cmdIO = IO.popen('mount|grep cgroup|grep blkio')
    output = cmdIO.readlines
    cmdIO.close
    output.first.match(/^[^\/]+(?<path>[^\s]+)\s.*/)
    path = "#{$~[:path]}/docker"
    return path
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
      container_stats[:blkio_ops] = File.open("#{@path}/#{container_id}/blkio.throttle.io_serviced").readlines
      container_stats[:blkio_bytes] = File.open("#{@path}/#{container_id}/blkio.throttle.io_service_bytes").readlines
      report << container_stats
    end
    return report
  end
end
end
end

