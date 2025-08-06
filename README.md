# Task Overview
The Utkrusht e-commerce platform runs a minimalist product catalog allowing users to filter by categories and brands. With the growing product list and user base, filtering endpoints now take several seconds to respond, especially when both category and brand filters are supplied. This latency is affecting sales and customer experience. The FastAPI application code is fully implemented (including all product, category, and brand endpoints), but the underlying PostgreSQL schema and raw query logic are not optimized for these frequent search patterns.

## Guidance
- Query execution is slow when filtering products using both category and brand because of missing or inefficient indexes on relevant columns.
- There are no composite indexes covering the (category_id, brand_id) filtering pattern, leading to full table scans.
- All route code and API schemas are done, but queries are blocking—the async interface isn't leveraged efficiently.
- Focus on the database schema and query logic for optimization; do not change the API contract or endpoint URLs.
- Use tools like EXPLAIN ANALYZE in a PostgreSQL client to inspect query plans and find sequential scans.
- Performance improvement is mostly achieved via schema/index tuning and more efficient query construction.

## Database Access
- Host: <DROPLET_IP>
- Port: 5432
- Database: utkrushtdb
- Username: utkrushtuser
- Password: utkrushtpass
Use any database client (e.g., pgAdmin, DBeaver, psql) to analyze, index, or monitor query execution plans.

## Objectives
- Identify which SQL queries and tables are slow by examining the execution plans for the product listing with category and brand filters.
- Update the schema by creating the most effective indexes for the main filtering (WHERE category_id=... AND brand_id=...) use case.
- Refactor the FastAPI query logic so that database interactions use async, non-blocking methods (using asyncpg or similar library as initialized in the application).
- Ensure that, after your optimization, filtered product listings return in under 500ms for typical queries.

## How to Verify
- Call the /products endpoint with category and brand filters before and after your changes, comparing response latency.
- Use EXPLAIN ANALYZE on the filter query to confirm the planner now uses your new composite index instead of sequential scans.
- Use a load testing tool (e.g., ab, wrk) if desired, or manually test to confirm performance is now consistently fast.
- If available, check pg_stat_statements or server logs for improved average query times and reduced load.
