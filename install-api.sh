#!/bin/bash

#------------------------ Project Setup -------------------#
CURRENT_WD=$(pwd)
echo '
	 PROJECT SETUP
------------------------'
	read -p "Enter name : " DIR_NAME 

	if [ -d $CURRENT_WD/$DIR_NAME ] 
	then 
		echo '
--------------------------------------------------------------
Folder with name already exists, rerun script with a new name!
--------------------------------------------------------------'
	else 
		mkdir $CURRENT_WD/$DIR_NAME
		cd $CURRENT_WD/$DIR_NAME
        
		npm init -y && \
		npm pkg delete scripts.test && npm set-script test "jest" && npm set-script build "tsc" && \
		npm pkg delete main && npm pkg set main="build/src/server.js" &&
		npm set-script dev:test "NODE_ENV=test ts-node-dev --respawn src/server.ts" && \
		npm set-script dev "ts-node-dev --respawn src/server.ts" && npx ts-jest config:init && \
		npm set-script start "node build/src/server.js" && npm set-script lint "eslint src/**/**/*.ts" && 
		npm i express config dotenv jsonwebtoken cookie-parser mysql2 helmet bcryptjs yup winston \
		swagger-jsdoc swagger-ui-express ts-node typescript && \
		npm i -D @types/express @types/config @types/node ts-node-dev \
		@types/jsonwebtoken @types/cookie-parser @types/mysql @types/bcryptjs \
		supertest jest ts-jest @types/jest @types/supertest @typescript-eslint/parser \
		eslint husky @types/swagger-jsdoc @types/swagger-ui-express && \
		mkdir -p config SQL src src/schema src/models src/middleware src/services src/routes \
		src/controllers src/utils __tests__ && \
		touch .env .env.template .gitIgnore .prettierrc.json \
		config/production.ts config/development.ts config/test.ts src/app.ts src/server.ts \
		src/middleware/verifyAccess.ts src/middleware/verifyRefresh.ts \
		src/utils/auth.utils.ts src/utils/db.ts src/utils/token.utils.ts src/utils/swagger.ts src/utils/logger.ts && \
		printf '{}' > .prettierrc.json && printf 'node_modules/ \nbuild/\nlogs/\n.env' > .gitIgnore && \
		npm set-script prepare "husky install" &&  \
		tsc --init && npx eslint --init && git init && 
		npm run prepare && npx husky add .husky/pre-commit "npm run lint" && \
		npm pkg delete scripts.prepare

		read -p "NPM install cors package, type Y | N to proceed : " NPM_PROCEED

		if [[ $NPM_PROCEED = 'Y' || $NPM_PROCEED = 'y' ]]
		then 
			npm i cors && npm i -D @types/cors && touch src/utils/cors.ts
		else
			echo '
-------------------------------
Cors package skipped
-------------------------------'
		fi
	fi
