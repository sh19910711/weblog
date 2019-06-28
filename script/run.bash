export HOST=$(aws ecs list-container-instances --query "containerInstanceArns" --output text --cluster homepage | xargs aws ecs describe-container-instances --cluster homepage --query 'containerInstances[].ec2InstanceId' --output text --container-instances | xargs aws ec2 describe-instances --query 'Reservations[].Instances[0].PrivateIpAddress' --output text --instance-ids)
export TASK_ID=$(aws ecs list-tasks --cluster homepage --query 'taskArns' --output text)
export DATABASE_HOST=$HOST
export DATABASE_PORT=$(aws ecs describe-tasks --cluster homepage --tasks ${TASK_ID} --query 'tasks[].containers[?name==`mysql`].networkBindings[0].hostPort' --output text)
export DATABASE_USERNAME=root
export DATABASE_PASSWORD=mysql
export SEARCH_HOST=$HOST
export SEARCH_PORT=$(aws ecs describe-tasks --cluster homepage --tasks ${TASK_ID} --query 'tasks[].containers[?name==`search`].networkBindings[0].hostPort' --output text)

PORT=8080 make dev
