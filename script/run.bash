# usage: HOST=... bash script/run.bash
export TASK_ID=$(aws ecs list-tasks --cluster homepage --query 'taskArns' --output text)
export DATABASE_HOST=$HOST
export DATABASE_PORT=$(aws ecs describe-tasks --cluster homepage --tasks ${TASK_ID} --query 'tasks[].containers[?name==`mysql`].networkBindings[0].hostPort' --output text)
export DATABASE_USERNAME=root
export DATABASE_PASSWORD=mysql
export SEARCH_HOST=$HOST
export SEARCH_PORT=$(aws ecs describe-tasks --cluster homepage --tasks ${TASK_ID} --query 'tasks[].containers[?name==`search`].networkBindings[0].hostPort' --output text)

PORT=8080 make dev
