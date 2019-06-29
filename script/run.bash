export TASK_ID=$(aws ecs list-tasks --cluster homepage --query 'taskArns' --output text)
export DATABASE_HOST=database.homepage2
export DATABASE_PORT=3306
export SEARCH_HOST=search.homepage2
export SEARCH_PORT=9200
PORT=8080 make dev
