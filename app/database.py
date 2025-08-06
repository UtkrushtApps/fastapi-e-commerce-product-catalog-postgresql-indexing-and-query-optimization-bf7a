import asyncpg

class Database:
    _pool = None

    @classmethod
    async def connect(cls):
        if cls._pool is None:
            cls._pool = await asyncpg.create_pool(
                user="utkrushtuser",
                password="utkrushtpass",
                database="utkrushtdb",
                host="db",
                port=5432,
                min_size=1,
                max_size=5
            )
    @classmethod
    async def fetch(cls, query, *args):
        async with cls._pool.acquire() as conn:
            return await conn.fetch(query, *args)
    @classmethod
    async def fetchrow(cls, query, *args):
        async with cls._pool.acquire() as conn:
            return await conn.fetchrow(query, *args)
    @classmethod
    async def execute(cls, query, *args):
        async with cls._pool.acquire() as conn:
            return await conn.execute(query, *args)
