# Message 
An application for creating a text self-destructing messages.

## Description
User can create a message. Application generates a
safe link to this saved message (like:
http://yourapp.com/message/ftr45e32fgv56d2 ​).

User is able to choose destruction options for messages:  
- after given number of link visits 
- after given number of hours

All the messages stored on the server side can be encrypted using
AES algorithm if user uses password while creation.

## Dependecies
 * [PostgreSQL](http://www.postgresql.org) 

## Installation
Copy configuration files

```
cp config/database.yml.example config/database.yml
```
Configure them with your data

## Used instruments
  - **Sinatra** - DSL for quickly creating web applications in Ruby