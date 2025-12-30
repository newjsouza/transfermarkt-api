"""Transfermarkt API - APEX-ML v4.0 Integration

FastAPI application for scraping Transfermarkt data.
"""

__version__ = "1.0.0"
__author__ = "Felipe Alves"
__description__ = "FastAPI for Transfermarkt data scraping - APEX-ML v4.0 Integration"

from .main import app

__all__ = ["app"]
