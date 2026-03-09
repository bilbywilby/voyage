# src/recipe_gen/preprocessing.py
from pathlib import Path
import cv2 
import numpy as np 

def preprocess_image(image_path: Path) -> np.ndarray:
    """
    Applies an OCR-focused image enhancement pipeline:
    Load -> Grayscale -> Adaptive Thresholding.
    Returns the processed image as a NumPy array (OpenCV format).
    """
    # 1. Load the image
    image = cv2.imread(str(image_path), cv2.IMREAD_COLOR)

    if image is None:
        raise FileNotFoundError(f"OpenCV could not load the image at: {image_path}")

    # 2. Convert to Grayscale
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    # 3. Apply Adaptive Thresholding
    processed_image = cv2.adaptiveThreshold(
        gray, 
        255, 
        cv2.ADAPTIVE_THRESH_GAUSSIAN_C, # Use Gaussian to weigh neighborhood pixels
        cv2.THRESH_BINARY,             # Black text on white background
        11,                            # Block size
        2                              # Constant C
    )

    return processed_image
