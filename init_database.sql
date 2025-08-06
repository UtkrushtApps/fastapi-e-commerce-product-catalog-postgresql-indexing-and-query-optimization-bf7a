-- Simple, inefficient product catalog schema (missing composite indexes)
CREATE TABLE IF NOT EXISTS categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(64) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS brands (
    id SERIAL PRIMARY KEY,
    name VARCHAR(64) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(128) NOT NULL,
    category_id INTEGER NOT NULL,
    brand_id INTEGER NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    CONSTRAINT fk_category FOREIGN KEY(category_id) REFERENCES categories(id),
    CONSTRAINT fk_brand FOREIGN KEY(brand_id) REFERENCES brands(id)
    -- Deliberately no indexes for category_id or brand_id columns
);

-- Sample data for demonstration
INSERT INTO categories (name) VALUES ('Electronics'), ('Apparel'), ('Books'), ('Games') ON CONFLICT DO NOTHING;
INSERT INTO brands (name) VALUES ('LogiTech'), ('Apple'), ('Nike'), ('Penguin'), ('Sony') ON CONFLICT DO NOTHING;

-- Insert 1000+ random products with random categories and brands
DO $$
DECLARE
    i INTEGER := 1;
BEGIN
    WHILE i <= 1000 LOOP
        INSERT INTO products (name, category_id, brand_id, price)
        VALUES ('Product '||i, (SELECT id FROM categories ORDER BY random() LIMIT 1), (SELECT id FROM brands ORDER BY random() LIMIT 1), round(random()*900+100,2))
        ON CONFLICT DO NOTHING;
        i := i + 1;
    END LOOP;
END; $$;
