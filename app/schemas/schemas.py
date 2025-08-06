from pydantic import BaseModel
from typing import Optional

class Product(BaseModel):
    id: int
    name: str
    category_id: int
    brand_id: int
    price: float

class Category(BaseModel):
    id: int
    name: str

class Brand(BaseModel):
    id: int
    name: str
