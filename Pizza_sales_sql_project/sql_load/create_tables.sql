-- Create orders table with primary key
CREATE TABLE public.orders_dim
(
    order_id INT PRIMARY KEY,
    date TEXT,
    time TEXT
);


-- Create pizza types table with primary key
CREATE TABLE public.pizza_types_dim
(
    pizza_type_id TEXT PRIMARY KEY,
    name VARCHAR(255),
    category VARCHAR(255),
    ingredients TEXT
);


-- Create pizzas table with primary key
CREATE TABLE public.pizzas_dim
(
    pizza_id TEXT PRIMARY KEY,
    pizza_type_id TEXT,
    size TEXT,
    price NUMERIC,
    FOREIGN KEY (pizza_type_id) REFERENCES public.pizza_types_dim (pizza_type_id)
);


-- Create order details table with primary key
CREATE TABLE public.order_details_dim
(
    order_details_id INT PRIMARY KEY,
    order_id INT,
    pizza_id TEXT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES public.orders_dim (order_id),
    FOREIGN KEY (pizza_id) REFERENCES public.pizzas_dim (pizza_id)
);

-- Set ownership of the tables to the postgres user
ALTER TABLE public.orders_dim OWNER to postgres;
ALTER TABLE public.pizza_types_dim OWNER to postgres;
ALTER TABLE public.pizzas_dim OWNER to postgres;
ALTER TABLE public.order_details_dim OWNER to postgres;

-- Create indexes on foreign key columns for better performance
CREATE INDEX idx_pizza_type_id ON public.pizza_types_dim (pizza_type_id);
CREATE INDEX idx_order_id ON public.orders_dim (order_id);
CREATE INDEX idx_pizza_id ON public.pizzas_dim (pizza_id);