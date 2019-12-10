COUNTER_TABLE_NAME=stellitime-api-counter
COUNTER_STACK_NAME=$(COUNTER_TABLE_NAME)-stack
AWS_DEFAULT_REGION=us-east-1

test:
	@DYNAMODB_LOCAL=1 python -m unittest --locals --verbose tests

ci-test: start-dynamodb
	docker-compose up --build --abort-on-container-exit --exit-code-from app app
	docker-compose down

start-dynamodb:
	docker-compose up -d dynamodb
	aws dynamodb create-table \
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
