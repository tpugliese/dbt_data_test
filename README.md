# dbt_data_test

## Test Setup

1. Git import clone this repository to your personal GitHub account and make it **Private**.
    - In your personal GitHub account, go to **Repositories** and click **New**.
    - Click **Import a Repository** hyperlink.
    - Enter the following:
        - **Your old repository's clone URL:** https://github.com/Wind-River-Systems/dbt_data_test.git
        - **Repository name:** dbt_data_test
    - Select: **Private**
    - Click **Begin import** and the repository will be cloned.
    - Click the repository link and go to the **Settings** tab.
    - Select **Collaborators** and click **Add people** and add the following colloaborators to your repository:
        - [jeffhuth-windriver](https://github.com/jeffhuth-windriver)
        - [jschintz-windriver](https://github.com/jschintz-windriver)
    - Go to your repository and click the green **Code** Clone button and copy the SSH URL (git@github...).
2. [Signup for a free Snowflake trial account](https://signup.snowflake.com/). **Choose:** Standard, AWS, Region: US West (Oregon), Other, Other, SQL. Then activate your Snowflake account and create a username and password.
3. Run the **following commands** in your Snowflake instance to create the role, database, and schema.

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

4. [Signup for a free dbt-Cloud developer account](https://www.getdbt.com/signup/). Verify and login. **Choose:** I have a data warehouse, Snowflake.

5. **Create Snowflake Connection** in dbt-Cloud. Enter the **following parameters**, click **test connection**, and **next**.
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

5. **Setup a Repository** in dbt-Cloud. Make sure you are logged in to your personal GitHub account.
    - Select **GitHub** and click **Connect GitHub Account**.
    - Click **Authorize dbt Cloud**, or enter your GitHub **Username** and **Password** and click **Sign in**.
    - Install on your personal account, select **All repositories** or **Only select repositories** (and select the new repository). Click **Install**.
    - Sometimes you may need to refresh the browser page and select the repository.
    - When **Your project is ready!**, select menu **Develop** to open the dbt-Cloud IDE.

6. Setup dbt-Cloud:
    - Run: dbt deps
    - Run: dbt seed
    - **Create branch** for upcoming exercises

7. For the following exercises, please follow dbt best practices:
    - [model naming](https://docs.getdbt.com/blog/stakeholder-friendly-model-names)
    - [model organization](https://docs.getdbt.com/guides/best-practices/how-we-structure/1-guide-overview)
    - [dbt style guide](https://github.com/dbt-labs/corp/blob/main/dbt_style_guide.md)
    - [other best practices](https://docs.getdbt.com/guides/legacy/best-practices)

8. Review the existing seeds, models, and YAML files in the project.

## dbt Test

1. Add a primary key (and if needed, a surrogate key) to all models in staging, intermediate, and marts. Ensure all primary keys are tested.

2. Add foreign key tests for all customer_id references in the subscription staging models.

3. Create three macros to add three new fields to the **customer** staging model.
    - get_first_name (macro): Takes an input parameter of full_name (First Last) and parses string to return only the first name in Title Case.
    - get_last_name (macro): Takes an input parameter of full_name (First Last) and parses string to return only the last name in Title Case.
    - get_zip_5 (macro): Takes a short or extended zip_code and returns the short 5-digit zip_code.
    - Update the **customer** staging model to add three new fields:
        - customer_first_name (text): Use macro to transform the customer_full_name.
        - customer_last_name (text): Use macro to transform the customer_full_name.
        - customer_zip_5_code (text): Use macro to transform the customer_zip_code.
    - Bring the 3 new fields through to intermediate and marts customer models.

4. Add the following fields to the intermediate and marts **customer** models:
    - order_count (integer): Number of orders placed by the customer
    - total_order_value (float): Total order value across all time for the customer
    - customer_cohort (text): Year-Month (yyyy-mm) of the customer's first order

5. Create an intermediate model: int_subscription__customer_cohort. Include the following fields:
    - customer_cohort (text)
    - customer_count (integer): Distinct count of customers in the cohort
    - order_count (integer): Number of orders across all time for all customers in the cohort
    - total_order_value (float): Total order value across all time for all customers in the cohort
    - Add order_count and total_order_value to dim_subscription__customer.

6. Create an intermediate model: int_subscription__customer_deliveries. Include the following fields:
    - customer_id (integer)
    - customer_full_name (text)
    - latest_scheduled_delivery_date (date): Most recent scheduled_delivery_date across all orders for the customer
    - avg_days_between_deliveries (float): Average number of days between each customer's scheduled deliveries.
    - Add latest_scheduled_delivery_date and avg_days_between_deliveries to dim_subscription__customer.

7. Create an intermediate model: int_subscription__customers_statuses based on customer subscription orders, activations, and cancellations. Include the following fields:
    - customer_id (integer)
    - customer_full_name (text)
    - customer_subscription_status (text): Customers who order can activate and cancel multiple times. Get the latest/current value for each customer. Values should be:
        - subscribed: Currently subscribed (ordered, activated, and not canceled)
        - canceled: Subscription activated then canceled
        - never-activated: Customer ordered but never activated
        - never-ordered: Customer never ordered
    - is_subscribed (boolean): subscribed status only; all other statuses are not subscribed
    - Add customer_subscription_status and is_subscribed to dim_subscription__customer.

8. Create an intermediate model: int_subscription__zip_code_summary. Include the following fields:
    - customer_zip_5_code (text): from #3 above
    - delivery_count (integer): Number of deliveries to that zip_code.
    - is_at_least_3 (boolean): Indicator for zip_codes with at least 3 deliveries.
    - avg_wait_time (float): Average time in days between scheduled_ship_date and scheduled_deliver_date for all orders to that zip_code.
    - wait_time_rank (integer): Rank the each zip_code based its average_wait_time in descending order.

9. Commit your changes, create a PR, and merge your changes to main. Then share the URL with the contributors (above).

10. Reply to the job recruiter via Jobvite and send them URL to your GitHub repository.
