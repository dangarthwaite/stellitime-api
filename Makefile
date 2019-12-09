COUNTER_TABLE_NAME=stellitime-api-counter
COUNTER_STACK_NAME=$(COUNTER_TABLE_NAME)-stack
AWS_DEFAULT_REGION=us-east-1

test:
	@DYNAMODB_LOCAL=1 python -m unittest --locals --verbose

clean-room-test:
	docker-compose up --exit-code-from app

start-dynamodb:
	docker-compose up -d dynamodb
	DYNAMODB_LOCAL=1 aws dynamodb create-table \
		--table-name  stellitime-api-counters \
		--attribute-definitions AttributeName=id,AttributeType=S \
		--key-schema AttributeName=id,KeyType=HASH \
		--provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 \
		--endpoint-url http://localhost:8000

stop-dynamodb:
	docker-compose down

requirements:
	pip3 install -r requirements.txt

deploy_dynamodb_table:
	aws cloudformation deploy \
     --template-file cloudformation/counter-table.yaml \
     --stack-name ${COUNTER_STACK_NAME} \
     --region $(AWS_DEFAULT_REGION)
