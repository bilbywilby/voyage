# src/recipe_gen/preprocessing.py
from pathlib import Path
import cv2
import numpy as np

def advanced_ocr_preprocessing(image_path: Path) -> np.ndarray:
    """Load image, convert to grayscale, and apply median blur for basic OCR prep."""
    # Note: cv2.IMREAD_COLOR is the default, but explicit for clarity
    img = cv2.imread(str(image_path), cv2.IMREAD_COLOR)
    if img is None:
        raise FileNotFoundError(f"OpenCV could not load the image at: {image_path}")
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    # Simple image enhancement for a minimal runnable example
    blurred = cv2.medianBlur(gray, 3) 
    return blurred
