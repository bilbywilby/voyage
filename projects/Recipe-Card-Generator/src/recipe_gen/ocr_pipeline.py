# src/recipe_gen/ocr_pipeline.py
import logging
from pathlib import Path
import pytesseract
from .preprocessing import advanced_ocr_preprocessing

logger = logging.getLogger(__name__)

# Minimal stub function required by the main script for demonstration
def parse_raw_text(raw_text: str) -> dict:
    """Returns a simple dict structure using the first line as the title."""
    title = raw_text.split('\n')[0].strip() if raw_text.strip() else "Untitled Recipe"
    return {"title": title, "raw_text": raw_text}

def image_to_text(image_path: Path) -> str:
    """Run OCR on a preprocessed image and return raw text."""
    try:
        preprocessed = advanced_ocr_preprocessing(image_path)
        # Use PSM 6: Assume a single uniform block of text
        text = pytesseract.image_to_string(preprocessed, config='--psm 6')
        logger.info("OCR completed successfully.")
        return text
    except pytesseract.TesseractNotFoundError:
        logger.error("Tesseract not found. Please install the Tesseract OCR engine.")
        raise
    except FileNotFoundError:
        raise
    except Exception as e:
        logger.error("OCR Processing Error: %s", e)
        return "" # Return empty string on other processing error
