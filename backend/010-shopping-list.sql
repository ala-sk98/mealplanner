BEGIN;

-- write a function that makes a query to join meal plan with meals with products and measure and 
-- returns product id, product name, quantity, unit
-- produces a shopping list for a single meal plan

create type app.shopping_list_item as (
    product_id BIGINT,
    product_name text,
    quantity numeric,
    unit text
);

create or replace function app.meal_plan_shopping_list(p app.meal_plan) returns setof app.shopping_list_item as $$

select app.product.id, app.product.name_en, SUM(app.measure.quantity), app.measure.unit 
from app.meal_plan
JOIN app.meal_plan_entry on app.meal_plan.id=app.meal_plan_entry.meal_plan_id
JOIN app.measure on app.meal_plan_entry.meal_id=app.measure.meal_id
JOIN app.product on app.measure.product_id=app.product.id
WHERE app.meal_plan.id = p.id
GROUP BY app.product.id, app.product.name_en, app.measure.unit;

$$ language sql stable;

GRANT execute on function app.meal_plan_shopping_list(app.meal_plan) to app_user, app_meal_designer, app_admin;
COMMIT;
