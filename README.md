# MemoEat
[http://memoeat.mahjam.es](http://memoeat.mahjam.es)

*-- 15 November 2016 --*

## Updates
1. Enabled users to upload their own photos when creating a new restaurant (using carrierwave & Amazon S3)
2. Improved responsive layout. Increased card height to allow more text.
3. Added AJAX for a better user experience.

## Technologies used
HTML, CSS, Bootstrap, Javascript, jQuery, Ruby, Sinatra, ActiveRecord, BCrypt, PostgreSQL, Zomato API, Carrierwave, Fog, Amazon S3

## Notes (To do)
1. Still requires refactoring
2. Input validation when creating new restaurants

---
*-- 4 November 2016 --*

## Goal
To build a full-stack application using Sinatra app and PostgreSQL. Implementation of 2 models and RESTful routes for the resources. Includes signup/log in functionality, with encrypted passwords & an authorization flow. Planning using wireframes, ORM, user stories and site diagram.

I decide to build a restaurant bookmarking app which each user can store data of each restaurant in the database. Functionality will include:
* searching for a restaurant to retrieve its details (using an api)
* adding restaurants to account
* archiving restaurants
* viewing collections of other users

## Technologies used
HTML, CSS, Bootstrap, Javascript, jQuery, Ruby, Sinatra, ActiveRecord, BCrypt, PostgreSQL, Zomato API

## Approach taken:
1. Built site diagram, wire frames and user stories
2. Obtained feedback from course instructors and coursemates
3. Revised wire frames
Development
4. Built general layout using html/css
5. Developed search function using Zomato API
6. Data storage using PostgreSQL
7. Created different views using different data sets from the database
8. User sign up/log in and authentification
9. CSS stuff (bootstrapping everything)

## App details
Some additional detail of the app
* Unable to add restaurant that has the same zomato api, but can add multiple instances of user created restaurants
* Browse section will not show user's own restaurants
* User cards will be shown from oldest first
* User archive will be shown from newest first
* Viewing other user account will show restaurant cards from newest first

## ANGRY bits
1. I try to be calm
2. Changing collapse of restaurant cards from mobile to desktop view a little fiddly. Used jQuery event to update the collapse based on width. On mobile, it will keep closing the cards when viewport size changes.

## Future works
1. Refactoring ruby code in ERB files, using better CSS class/id names.
2. Input pattern validation
3. Currently only searches for restaurants in Melbourne. Enable user to change location for search.
4. App to recommend user some restaurants based on rating/preferences.
5. Enable user to upload their own photos when creating a new restaurant instead of using a link. (Use carrierwave & Amazon S3)
6. Improve responsive layout. Change the way the collapse toggles from mobile to desktop.
7. Improve responsive layout. Improve on sizing of cards. If there is too much text it will overflow.
