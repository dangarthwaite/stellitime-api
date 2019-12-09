COUNTER_TABLE_NAME=stellitime-api-counter
COUNTER_STACK_NAME=$(COUNTER_TABLE_NAME)-stack
AWS_DEFAULT_REGION=us-east-1

test:
	@python -m unittest --locals --quiet tests

clean-room-test:
	docker-compose up --exit-code-from app

start-dynamodb:
	docker-compose up -d  dynamodb

stop-dynamodb:
	docker-compose down dynamodb

requirements:
	pip3 install -r requirements.txt

deploy_dynamodb_table:
	aws cloudformation deploy \
     --template-file cloudformation/counter-table.yaml \
     --stack-name ${COUNTER_STACK_NAME} \
     --region $(AWS_DEFAULT_REGION)
