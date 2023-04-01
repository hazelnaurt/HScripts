#!/bin/bash

#------------------------ Project Setup -------------------#
CURRENT_WD=$(pwd)
PVALUE=0
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
		sed "/main/s|index.js|build/src/server.js|" package.json > package.json2 && rm package.json && mv package.json2 package.json && \
		npm pkg delete scripts.test && npm pkg set scripts.test="jest" && npm pkg set scripts.build="tsc" && \
		npm pkg set scripts.dev:test="NODE_ENV=test ts-node-dev --respawn src/server.ts" && \
		npm pkg set scripts.dev="ts-node-dev --respawn src/server.ts" && npx ts-jest config:init && \
		npm pkg set scripts.start="node build/src/server.js" && npm pkg set scripts.lint="eslint src/**/**/*.ts" && 
		npm i express config dotenv jsonwebtoken bcryptjs yup winston \
		express-graphql graphql@15.3.0 graphql-middleware graphql-shield graphql-depth-limit \
		prisma @prisma/client @pothos/core @pothos/plugin-prisma graphql-scalars && \
		npm i -D @types/express @types/config @types/node ts-node-dev ts-node typescript supertest @types/supertest \
		@types/jsonwebtoken @types/bcryptjs jest ts-jest @types/jest @typescript-eslint/parser \
		eslint husky @types/graphql-depth-limit && \
		mkdir -p config src src/permissions src/modules src/utils __tests__ && \
		touch .env .env.template .gitIgnore .prettierrc.json \
		config/production.ts config/development.ts config/test.ts src/server.ts src/permissions/index.ts \
		src/utils/schema.utils.ts src/utils/builder.utils.ts src/utils/token.utils.ts src/utils/logger.utils.ts && \
		printf '{}' > .prettierrc.json && printf 'node_modules/ \nbuild/ \nlogs/ \nprisma/migrations/**/ \n.env' > .gitIgnore && \
		npm pkg set scripts.prepare="husky install" &&  \
		npx eslint --init && git init &&  \
		npx prisma init --datasource-provider mysql && \
		npm run prepare && npx husky add .husky/pre-commit "npm run lint" && \
		npm pkg delete scripts.prepare && \
		tsc --init || PVALUE=1 
		
		if [ $PVALUE = 1 ] 
		then
			npm install -g typescript && \
			tsc --init && \
			printf 'Inside the conty'
		fi

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
