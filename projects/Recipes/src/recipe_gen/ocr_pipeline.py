# src/recipe_gen/ocr_pipeline.py
import json
import re
import shutil
from pathlib import Path
from typing import Dict, Any, List
import logging

import pytesseract
import numpy as np 
from PIL import Image 
from jinja2 import Environment, select_autoescape

# --- Data Model ---
class Recipe:
    """Mock class representing the structured output of the parsing module."""
    def __init__(self, title: str, yield_amount: str, ingredients: List[Dict], instructions: List[str]):
        self.title = title
        self.yield_amount = yield_amount
        self.ingredients = ingredients
        self.instructions = instructions

    def to_dict(self) -> Dict[str, Any]:
        """Converts the Recipe object to the target JSON schema."""
        return {
            "title": self.title,
            "yield": self.yield_amount,
            "ingredients": self.ingredients,
            "instructions": self.instructions,
            "notes": "Data was generated using a beta mock parser."
        }


# --- Pipeline Helpers ---

def _ensure_tesseract_binary():
    """Checks if the tesseract executable is available on the system PATH."""
    return shutil.which("tesseract") is not None

# Global flag to check environment availability
_OCR_AVAILABLE = _ensure_tesseract_binary()

def generate_filename_prefix(title: str) -> str:
    """
    Creates a clean, lowercase, underscore-separated filename prefix from a title.
    """
    title = re.sub(r'[^\w\s-]', '', title).strip().lower()
    title = re.sub(r'[-\s]+', '_', title)
    return title.strip('_')


def image_to_text(image_path: str, preprocess: bool) -> str:
    """
    OCR step: Runs Tesseract on the image, optionally after preprocessing.
    """
    from .preprocessing import preprocess_image 

    path_obj = Path(image_path)
    
    if preprocess:
        processed_image = preprocess_image(path_obj)
        return pytesseract.image_to_string(processed_image, lang="eng")
    else:
        return pytesseract.image_to_string(str(path_obj), lang="eng")


def parse_raw_text(raw_text: str) -> Recipe:
    """
    MOCK PARSER: Converts raw OCR text into the structured Recipe object.
    Returns mock data to ensure the rest of the pipeline works.
    """
    lines = [line.strip() for line in raw_text.split('\n') if line.strip()]
    title_candidate = lines[0] if lines else "Untitled Recipe Card"

    mock_ingredients = [
        {"name": "All-purpose flour", "amount": 2.0, "unit": "cup", "notes": "sifted"},
        {"name": "Granulated sugar", "amount": 1.5, "unit": "cup", "notes": "divided"},
        {"name": "Unsalted butter", "amount": 0.5, "unit": "cup", "notes": "softened"},
    ]
    mock_instructions = [
        "Combine dry ingredients.",
        "Cream butter and sugar.",
        "Mix in the milk and vanilla.",
        "Bake at 350°F for 20 minutes."
    ]

    if 5 < len(title_candidate) < 60:
         mock_title = title_candidate
    else:
         mock_title = "Min Cream Cheese Cupcakes (Mummy's Recipe)"

    return Recipe(
        title=mock_title,
        yield_amount="2.5 dozen mini cupcakes",
        ingredients=mock_ingredients,
        instructions=mock_instructions
    )


def recipe_to_dict(recipe: Recipe) -> Dict[str, Any]:
    """Converts the internal Recipe object to a standard Python dictionary."""
    return recipe.to_dict()


def create_recipe_card(recipe: Recipe) -> str:
    """
    MOCK RENDERER: Renders the Recipe object into an HTML card.
    """
    JINJA_ENV = Environment(autoescape=select_autoescape(['html', 'xml']))
    
    template_str = """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>{{ recipe.title | default('Recipe Card') }}</title>
    <style>
        body { font-family: sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #ccc; }
        h1 { color: #5a5a5a; border-bottom: 2px solid #ccc; padding-bottom: 5px; }
        ul, ol { padding-left: 20px; }
    </style>
</head>
<body>
    <h1>{{ recipe.title | default('Untitled Recipe') }}</h1>
    <p><strong>Yield:</strong> {{ recipe.yield_amount | default('N/A') }}</p>

    <h2>Ingredients</h2>
    <ul>
    {% for item in recipe.ingredients %}
        <li><strong>{{ item.amount | default('') }} {{ item.unit | default('') }}</strong> {{ item.name }} 
            {% if item.notes %} ({{ item.notes }}){% endif %}
        </li>
    {% endfor %}
    </ul>

    <h2>Instructions</h2>
    <ol>
    {% for step in recipe.instructions %}
        <li>{{ step }}</li>
    {% endfor %}
    </ol>
</body>
</html>
"""
    template = JINJA_ENV.from_string(template_str)
    
    return template.render(recipe=recipe)


def save_original_image(source_path: str, dest_dir: str):
    """Copies the original image to the specified output directory."""
    source = Path(source_path)
    dest = Path(dest_dir) / source.name
    shutil.copy2(source, dest)
