#!/bin/sh

echo "Cloning repositories..."

PROJECTS=$HOME/Projects
WORDPROOF=$CODE/wordproof

git clone git@github.com:marijnbent/flower.git $PROJECTS/flower
git clone git@github.com:marijnbent/flower-laravel.git $PROJECTS/flower-laravel

git clone git@github.com:wordproof/myv2.git $WORDPROOF/my
