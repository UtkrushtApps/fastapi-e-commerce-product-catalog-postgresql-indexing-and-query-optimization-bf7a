from fastapi import APIRouter, Query
from typing import List, Optional
from app.schemas.schemas import Product, Category, Brand
from app.database import Database
from fastapi import HTTPException

router = APIRouter()

@router.on_event("startup")
async def on_startup():
    await Database.connect()

@router.get("/products", response_model=List[Product])
async def list_products(
    category_id: Optional[int] = Query(None),
    brand_id: Optional[int] = Query(None)
):
    # Inefficient: No WHERE clause fallback to sequential scan if any filter not present, no index usage.
    base = "SELECT id, name, category_id, brand_id, price FROM products"
    conds = []
    params = []
    if category_id is not None:
        conds.append("category_id = $1")
        params.append(category_id)
    if brand_id is not None:
        if conds:
            conds.append("brand_id = $2")
            params.append(brand_id)
        else:
            conds.append("brand_id = $1")
            params.append(brand_id)
    if conds:
        where = " WHERE " + " AND ".join(conds)
        query = base + where
    else:
        query = base
    # Deliberate inefficiency: hardcoded parameter positions, unoptimized filters, no order
    recs = await Database.fetch(query, *params)
    return [Product(**dict(rec)) for rec in recs]

@router.get("/categories", response_model=List[Category])
async def list_categories():
    recs = await Database.fetch("SELECT id, name FROM categories")
    return [Category(**dict(rec)) for rec in recs]

@router.get("/brands", response_model=List[Brand])
async def list_brands():
    recs = await Database.fetch("SELECT id, name FROM brands")
    return [Brand(**dict(rec)) for rec in recs]
