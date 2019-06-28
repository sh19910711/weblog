libdir = File.join(File.dirname(__FILE__), './homepagelib')
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)
puts 'require ok'

require 'aws-sdk'

CLUSTER = 'homepage'
def host
  ecs = Aws::ECS::Client.new
  ec2 = Aws::EC2::Client.new
  ci = ecs.list_container_instances(cluster: CLUSTER).first
  arns = ci[:container_instance_arns]
  ci = ecs.describe_container_instances(cluster: CLUSTER, container_instances: arns)
  instance_id = ci[:container_instances][0][:ec2_instance_id]
  ec2.describe_instances(instance_ids: [instance_id])[:reservations][0][:instances][0][:private_ip_address]
end
def port
  # export TASK_ID=$(aws ecs list-tasks --cluster homepage --query 'taskArns' --output text)
  # export DATABASE_PORT=$(aws ecs describe-tasks --cluster homepage --tasks ${TASK_ID} --query 'tasks[].containers[?name==`mysql`].networkBindings[0].hostPort' --output text)
  ecs = Aws::ECS::Client.new
  tasks = ecs.list_tasks(cluster: CLUSTER)[:task_arns]
  port = ecs.describe_tasks(cluster: CLUSTER, tasks: tasks).tasks.map do |t|
    t[:containers]
  end.to_a.flatten.select do |c|
    c[:name] == 'mysql'
  end.first[:network_bindings].first[:host_port].to_s

  port
end
ENV['DATABASE_HOST'] = '10.0.1.174' # host
puts "host"
ENV['DATABASE_PORT'] = '32787' # port
puts "port"
ENV['DATABASE_USERNAME'] = 'root'
ENV['DATABASE_PASSWORD'] = 'mysql'

require 'database'
require 'model'
require 'content'
require 'storage'


def handler(event:, context:)
  puts 'model'
  Model::Note.all.map(&:subject)
end

if __FILE__ == $0
  puts handler(event: nil, context: nil)
end
