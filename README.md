# dbt_data_test
## Wind River dbt data test

1. Git clone this repository to your personal GitHub account. Make the repository private and share the repository with: [jeffhuth-windriver](jeffhuth-windriver) and  [jschintz-windriver](https://github.com/jschintz-windriver).
2. [Signup for a free Snowflake trial account](https://signup.snowflake.com/). Choose: Standard, AWS, Region: US West (Oregon), Other, Other, SQL. Then activate your Snowflake account and create a username and password.
3. Run the following commands in your Snowflake instance to create the role, database, and schema.

```
-- Set variables for admin role, db, schema, warehouse
set this_role = 'data_test_role';
set this_db = 'data_test';
set this_schema = 'subscription';
set this_warehouse = 'compute_wh';
set this_db_schema = concat($this_db, '.', $this_schema);

-- Create role and assign warehouse grants
use role securityadmin;
create role if not exists identifier($this_role);
grant operate on warehouse identifier($this_warehouse) to role identifier($this_role);
grant usage on warehouse identifier($this_warehouse) to role identifier($this_role);
grant role identifier($this_role) to role sysadmin;

-- Create database and schema
use role sysadmin;
create database if not exists identifier($this_db);
create schema if not exists identifier($this_db_schema);

-- Assign database and schema grants
use role securityadmin;
grant usage on database identifier($this_db) to role identifier($this_role);
grant usage on all schemas in database identifier($this_db) to role identifier($this_role);
grant all privileges on schema identifier($this_db_schema) to role identifier($this_role);
grant all privileges on all tables in schema identifier($this_db_schema) to role identifier($this_role);
grant all privileges on future tables in schema identifier($this_db_schema) to role identifier($this_role);
grant all privileges on all views in schema identifier($this_db_schema) to role identifier($this_role);
grant all privileges on future views in schema identifier($this_db_schema) to role identifier($this_role);
```

4. [Signup for a free dbt-Cloud developer account](https://www.getdbt.com/signup/). Verify and login. Choose: I have a data warehouse, Snowflake.

5. Create Snowflake connection in dbt-Cloud. Enter the following, test connection, and next.
```
Name: Snowflake
Account: YOUR_SNOWFLAKE_ID (from your Snowflake URL, the xxxxxxxx in https://app.snowflake.com/prod3.us-west-2.aws/xxxxxxxx/)
Database: data_test
Warehouse: compute_wh
Role: data_test_role
Keep Session Alive: unchecked
Auth Method: Username & Password
Username: YOUR_USERNAME (from step 2 above)
Password: YOUR_PASSWORD (from step 2 above)
Schema: subscription
```

5. Setup a Repository.


18. Please follow dbt best practices for [model naming](https://docs.getdbt.com/blog/stakeholder-friendly-model-names) and [model organization](https://docs.getdbt.com/guides/best-practices/how-we-structure/1-guide-overview).
19. Bonus points for setting up and passing [dbt project evaluator](https://docs.getdbt.com/blog/align-with-dbt-project-evaluator).
