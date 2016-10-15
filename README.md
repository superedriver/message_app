[![Build Status](https://travis-ci.org/superedriver/message_app.svg?branch=master)](https://travis-ci.org/superedriver/message_app)

# Message 
An application for creating a text self-destructing messages.

## Description
User can create a message. Application generates a
safe link to this saved message (like:
http://messageapp.com/message/ftr45e32fgv56d2 ​).

User is able to choose destruction options for messages:  
- after given number of link visits 
- after given number of hours

All the messages stored on the server side can be encrypted using
AES algorithm if user uses password while creation.

## Dependecies
 * [PostgreSQL](http://www.postgresql.org) 

## Installation
1. Go to project folder

2. Copy configuration files

```
cp config/database.yml.example config/database.yml
```
Configure them with your data

3. Install needed gems
```
bundle install
```

4. Run migrations
```
bundle exec rake db:migrate
```

5. Install cron job for deleting expired messages
```
whenever --update-crontab
```

## Used instruments
  - **Sinatra** - DSL for quickly creating web applications in Ruby