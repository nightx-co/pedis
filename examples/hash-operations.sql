DELETE FROM redis.hashes WHERE key = 'cart:user:8842';

--- 1. Adding Items to Cart with Quantities ---
-- Store product IDs as fields and their quantities as values
SELECT redis.hset('cart:user:8842', 'prod_laptop_99', '1');
SELECT redis.hset('cart:user:8842', 'prod_mouse_04', '2');
SELECT redis.hset('cart:user:8842', 'prod_keyboard_12', '1');

--- 2. Inspecting a Single Item Quantity ---
SELECT redis.hget('cart:user:8842', 'prod_mouse_04') AS mouse_quantity;

--- 3. Adjusting Quantities (Incrementing items) ---
-- User decided to buy one more mouse (+1)
SELECT redis.hincrby('cart:user:8842', 'prod_mouse_04', 1) AS updated_mouse_qty;

--- 4. Removing an Item from the Cart ---
-- User removed the keyboard entirely
SELECT redis.hdel('cart:user:8842', 'prod_keyboard_12') AS item_removed;

--- 5. Reviewing the Final Cart Contents ---
SELECT redis.hgetall('cart:user:8842') AS final_shopping_cart;