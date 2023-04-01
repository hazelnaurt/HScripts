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
		npm pkg delete scripts.test && npm pkg set scripts.build="tsc" && \
		npm pkg set scripts.dev="ts-node-dev --respawn src/index.ts" && \
		npm pkg set scripts.start="node build/src/index.js" && \
		npm i dotenv && \
		npm i -D @types/node ts-node-dev ts-node typescript && \
		mkdir -p src && \
		touch .env .gitIgnore src/index.ts && \
		printf 'node_modules/ \nbuild/ \n.env' > .gitIgnore && \
		tsc --init || PVALUE=1 
		
		if [ $PVALUE = 1 ] 
		then
			npm install -g typescript && \
			tsc --init && \
			printf 'Inside the conty'
		fi
	fi
