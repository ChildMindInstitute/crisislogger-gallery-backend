#!/bin/sh
# Terminate execution if any command fails
set -e

start=$(date +%s)

[[ $1 == '' ]] && BRANCH="dev" || BRANCH=$1

git pull
git pull origin $BRANCH

git push
git push origin $BRANCH

SSH_KEY_PATH="$HOME/dev/ssh/crisisfinal"
SERVER="crisislogger@35.245.250.150"
GIT_REPO="git@gitlab.com:asaadriaz/cl-gallery-back.git"
BASE_DIR="/home/crisislogger/web/back.crisislogger.org/"
DEST_FOLDER=$BASE_DIR"public_html"
STORAGE_FOLDER=$BASE_DIR"storage"
USER="crisislogger"
USER_GROUPE="www-data"

PARAMS=" \
 BRANCH=\"$BRANCH\" \
 USER=\"$USER\" \
 GIT_REPO=\"$GIT_REPO\" \
 USER_GROUPE=\"$USER_GROUPE\" \
 BASE_DIR=\"$BASE_DIR\" \
 DEST_FOLDER=\"$DEST_FOLDER\" \
 STORAGE_FOLDER=\"$STORAGE_FOLDER\" \
 "

echo ===================================================
echo Autodeploy server
echo selected branch $BRANCH
chmod 400 $SSH_KEY_PATH
echo ===================================================
echo Connecting to remote server...
ssh -i $SSH_KEY_PATH $SERVER $PARAMS 'bash -i' <<-'ENDSSH'
  #Connected
  # Terminate execution if any command fails
  set -e

  BUILD1=$BASE_DIR"build1"
  BUILD2=$BASE_DIR"build2"

	if [ -d $BUILD1 ]; then
	  NEW_BUILD=$BUILD2
	  OLD_BUILD=$BUILD1
  else
	  NEW_BUILD=$BUILD1
	  OLD_BUILD=$BUILD2
  fi


  rm -rf $NEW_BUILD
  mkdir $NEW_BUILD
  cd $NEW_BUILD

	# activate maintenance mode
  #	php artisan down
  # git stash
  # to stash package-lock.json file changes

  git clone -b $BRANCH --depth 1  $GIT_REPO  .

  # git pull
  #git checkout $BRANCH
  #git pull origin $BRANCH

	# update PHP dependencies
	composer install --no-interaction --no-dev --prefer-dist --optimize-autoloader
  #	composer update --no-interaction --no-dev --prefer-dist --optimize-autoloader --ignore-platform-reqs
	# --no-progress
	# --no-interaction Do not ask any interactive question
	# --no-dev  Disables installation of require-dev packages.
	# --prefer-dist  Forces installation from package dist even for dev versions.# update database

	cp .env.prod .env
	# php artisan key:generate
	# php artisan jwt:secret

#	npm install
#	npm run prod

	php artisan migrate --force
	# --force  Required to run when in production.

	# php artisan migrate --seed

	if [ -d $STORAGE_FOLDER ]; then
    rm -rf storage
  else
    mv storage $STORAGE_FOLDER
  fi

  ln -s $STORAGE_FOLDER ./

  php artisan storage:link


  sudo chown -R $USER:$USER_GROUPE $(pwd)
  sudo find $(pwd) -type d -exec chmod 775 {} \;
  sudo find $(pwd) -type f -exec chmod 664 {} \;

  sudo chown -R $USER:$USER_GROUPE $STORAGE_FOLDER
  sudo find $STORAGE_FOLDER -type d -exec chmod 775 {} \;
  sudo find $STORAGE_FOLDER -type f -exec chmod 664 {} \;

	php artisan config:clear
	php artisan cache:clear
	php artisan route:clear
	php artisan view:clear
	php artisan optimize

  cd $BASE_DIR

  sudo rm -rf $DEST_FOLDER
  sudo ln -sf $NEW_BUILD $DEST_FOLDER
  sudo rm -rf $OLD_BUILD

	# stop maintenance mode
  # php artisan up

  exit
ENDSSH

end=$(date +%s)

runtime=$((end - start))
echo deploy took $runtime seconds
