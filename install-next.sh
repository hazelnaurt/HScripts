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
		npx create-next-app@latest --example with-jest $DIR_NAME && \
		cd $CURRENT_WD/$DIR_NAME && \
        npm i -D eslint @typescript-eslint/eslint-plugin @typescript-eslint/parser next-sitemap \
        husky msw eslint-config-next eslint-plugin-testing-library eslint-plugin-jest-dom && \
        rm -rf __tests__/* styles/* pages/index.module.css && mkdir -p components lib hooks context \
        __tests__/__mocks__/msw __tests__/__mocks__/fakeData __tests__/UI && 
        touch __tests__/__mocks__/msw/handlers.js .env.local next.config.js lib/auth.ts \
        __tests__/__mocks__/msw/server.js .env.template .prettierrc.json next-sitemap.config.js \
        context/AppContextProvider.tsx context/AppReducer.ts hooks/useAppContext.tsx hooks/useAuth.tsx && \
        printf '{}' > .prettierrc.json && \
        printf '\n# seo\npublic/robots.txt\npublic/sitemap.xml' >> .gitignore && \
        npm pkg set scripts.lint="next lint" && \
        npm pkg set scripts.postinstall="next-sitemap" && \
        npm pkg set scripts.prepare="husky install" &&  \
        npm run prepare && npx husky add .husky/pre-commit "npm run lint" && \
        npm pkg delete scripts.prepare
	fi

    PS3="Select CSS Framework: "

    framework=("Material-UI" "TailwindCSS")

    while true; do
        select item in "${framework[@]}"
        do
            case $REPLY in
                1) 
                    npm i @mui/material @emotion/react @emotion/styled @mui/icons-material @mui/base @mui/lab; 
                    break 2;;
                2) 
                    npm i -D autoprefixer@latest postcss@latest tailwindcss@latest && \
                    touch styles/global.css && npx tailwindcss init -p
                    if [ -f "-0" ] 
                    then
                        mv -0 tailwindcss.config.js 
                    fi
                    printf '@tailwind base;\n@tailwind components;\n@tailwind utilities;' > styles/global.css; 
                    break 2;;
                *) echo "Ooops - unknown choice $REPLY"; break;
            esac
        done
    done

    read -p "
    Install Cypress for E2E testing, type Y | N to proceed : " CYPRESS_PROCEED

    if [[ $CYPRESS_PROCEED = 'Y' || $CYPRESS_PROCEED = 'y' ]]
		then 
			npm i -D cypress @testing-library/cypress env-cmd start-server-and-test && \
            npm pkg set scripts.cy:open="env-cmd -f .env.local cypress open" && \
            npm pkg set scripts.cy:start="start-server-and-test 'npm start' 3000 'npm run cy:open'" && \
            npm pkg set scripts.cy:build="npm run build && npm run cy:start" 
		else
			echo '
-------------------------------
Cypress & testing-library/cypress skipped
-------------------------------'
		fi
