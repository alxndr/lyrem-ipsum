Deploy
======

* `export APP=<heroku name>`
* `heroku addons:add heroku-postgresql:dev --app $APP
* `heroku pg:wait --app $APP to see if db is up?
* `heroku config --app $APP | grep HEROKU_POSTGRESQL
* `heroku pg:promote $URL --app $APP
* `git push <git name>`
* `rake db:create db:migrate`
