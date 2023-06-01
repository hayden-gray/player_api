# Player API README

* Ruby Version 3.0.1
* Rails Version 7.0.5

## Getting Started
To run this app locally you will need to follow a few basic steps. This assumes you have already cloned the repo and are in the root directory.

##### Create and migrate your local database\
>rails db:create db:migrate
##### Install necessary gems
>bundle install
##### Populate your database
> bundle exec rake players:update

(note: will take 2-3 minutes)
##### Optional: Initialize scheduled player db updates
>bundle exec wheneverize .

>whenever --update-crontab

## Usage
There are 2 endpoints available in this project the show (or single player endpoint), and the search endpoint

##### Show endpoint
This endpoint returns a single player. Here is an example curl request to hit the endpoint
>curl http://localhost:3000/players/123

##### Search endpoint
This endpoint can take one, all, or any combination of the following parameters and will return a set of players based on those.
* Sport (football, basketball, baseball)
* First letter of last name
* A range of ages (ex. 25-30)
* The player’s position (ex: “QB”)

Example:
>curl http://localhost:3000/player_search\?age_range\=22-23\&sport\=football\&last_name\=B\&position\=DB

Authored by Hayden Gray
