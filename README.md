SQL:Origin
==========

Adds backtraces to your SQL queries and query logs, so you know where your
queries are coming from. This only works with Rails, and is only tested with
Rails 3.2.

Why do I want this?
-------------------

Simple. To turn this

![Without backtrace logging](https://img.skitch.com/20120614-rg8sqa2t7eweaj4swjqcufrcjr.png)

into this.

![With backtrace logging](https://img.skitch.com/20120614-kcisbjqiaxfwbq82wbjm4iumfa.png)

So now, you needn't wonder where that odd-looking or broken SQL query is coming
from.

It can also turn this

````
Reading mysql slow query log from /usr/local/mysql/data/mysqld51-apple-slow.log
Count: 1  Time=4.32s (4s)  Lock=0.00s (0s)  Rows=0.0 (0), root[root]@localhost
 SELECT "events".* FROM "events" WHERE "events"."bug_id" = ?

Count: 3  Time=2.53s (7s)  Lock=0.00s (0s)  Rows=0.0 (0), root[root]@localhost
 SELECT "deploys".* FROM "deploys" WHERE "deploys"."id" = ?

Count: 3  Time=2.13s (6s)  Lock=0.00s (0s)  Rows=0.0 (0), root[root]@localhost
 SELECT * FROM "slugs" WHERE (LOWER("slugs"."slug") = LOWER(?) AND "slugs"."scope" IS NULL AND "slugs"."sluggable_type" = ?) LIMIT 1
````

into this.

````
Reading mysql slow query log from /usr/local/mysql/data/mysqld51-apple-slow.log
Count: 1  Time=4.32s (4s)  Lock=0.00s (0s)  Rows=0.0 (0), root[root]@localhost
 SELECT "events".* FROM "events" WHERE "events"."bug_id" = ? /* app/models/project.rb:125:in `_callback_after_617' */

Count: 3  Time=2.53s (7s)  Lock=0.00s (0s)  Rows=0.0 (0), root[root]@localhost
 SELECT "deploys".* FROM "deploys" WHERE "deploys"."id" = ? /* app/controllers/projects_controller.rb:359:in `require_or_load' */

Count: 3  Time=2.13s (6s)  Lock=0.00s (0s)  Rows=0.0 (0), root[root]@localhost
 SELECT * FROM "slugs" WHERE (LOWER("slugs"."slug") = LOWER(?) AND "slugs"."scope" IS NULL AND "slugs"."sluggable_type" = ?) LIMIT 1 /* app/models/observers/bug_observer.rb:23:in `create_open_event' */
````

Installation
------------

To use, add SQL:Origin to your Gemfile:

```` ruby
gem 'sql_origin'
````

If you would like to add three-line backtraces below every SQL query in your
Rails log, add

```` ruby
SQLOrigin.append_to_log
````

somewhere in your Rails initialization (e.g., `application.rb` or a
`config/initializer` file).

If you would like to add a one-line backtrace comment to every SQL query, add

```` ruby
SQLOrigin.append_to_query
````

somewhere in your Rails initialization.

It would be typical to enable `append_to_log` for development and test, and
`append_to_query` for production, in order to keep production logs small.

### Backtrace Filtering

By default, files not under your Rails root, and files under `vendor`, are
filtered from your backtrace. If you need to filter other files, add them to
{SQLOrigin::LIBRARY_PATHS}:

```` ruby
SQLOrigin::LIBRARY_PATHS << 'config/initializers/active_record_hacks.rb'
````
