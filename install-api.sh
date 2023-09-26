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
		sed "/main/s|index.js|build/server.js|" package.json > package.json2 && rm package.json && mv package.json2 package.json && \
		npm pkg delete scripts.test && npm pkg set scripts.test="jest" && npm pkg set scripts.build="tsc" && \
		npm pkg set scripts.watch="nodemon -e ts -w ./ -x npm run dev" && \
		npm pkg set scripts.dev="npm run swagger-autogen && ts-node-dev --respawn server.ts" && npx ts-jest config:init && \
		npm pkg set scripts.start="NODE_ENV=production node build/server.js" && npm pkg set scripts.lint="eslint . --ext .ts" && 
		npm pkg set scripts.swagger-autogen="ts-node-dev swagger.ts && sed '2d' swagger.json > swagger.json2 && rm swagger.json && mv swagger.json2 swagger.json" && \
		npm pkg set scripts.test-svr="ts-node-dev --respawn test-server.ts" && \
		npm i express config dotenv jsonwebtoken cookie-parser helmet bcryptjs yup winston \
		swagger-ui-express swagger-autogen && \
		npm i -D ts-node typescript @types/express @types/config @types/node ts-node-dev prisma @prisma/client \
		@types/jsonwebtoken @types/cookie-parser @types/bcryptjs nodemon\
		supertest jest ts-jest @types/jest @types/supertest @typescript-eslint/parser \
		eslint husky @types/swagger-ui-express && \
		mkdir -p config schema middleware routes \
		controllers utils __tests__ && \
		touch .env .env.template .gitIgnore .prettierrc.json .eslintignore swagger.ts swagger.json \
		config/production.ts config/development.ts config/test.ts app.ts server.ts buildspec.yml \
		middleware/verifyAccess.ts middleware/uploadFiles.ts middleware/verifyRefresh.ts utils/aws.utils.ts \
		utils/auth.utils.ts utils/db.utils.ts utils/token.utils.ts utils/logger.utils.ts utils/fileupload.utils.ts && \
		printf '{}' > .prettierrc.json && printf 'node_modules/ \nbuild/ \nlogs/ \nprisma/migrations/**/ \n.env' > .gitIgnore && \
		printf 'node_modules/' > .eslintignore && \
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
			npm i cors && npm i -D @types/cors && touch utils/cors.utils.ts
		else
			echo '
-------------------------------
Cors package skipped
-------------------------------'
		fi
	fi
