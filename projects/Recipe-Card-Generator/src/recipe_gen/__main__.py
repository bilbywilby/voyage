# src/recipe_gen/__main__.py - CLI Entry Point
import argparse
import logging
from pathlib import Path
from .ocr_pipeline import image_to_text, parse_raw_text

logging.basicConfig(level=logging.INFO)

def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        prog="recipe-gen",
        description="Extract raw recipe text from an image."
    )
    parser.add_argument("image_path", type=Path, help="Path to the recipe image")
    return parser.parse_args()

def main() -> None:
    args = parse_args()
    if not args.image_path.exists():
        logging.error("Image file not found: %s", args.image_path)
        return

    try:
        # 1. OCR Stage
        raw = image_to_text(args.image_path)
        
        # 2. Parsing Stage (minimal stub execution)
        parsed_data = parse_raw_text(raw)

        print("\n--- RECIPE CARD GENERATOR: OCR RESULT ---")
        print(f"Title Candidate: {parsed_data['title']}")
        print("----------------------------------------")
        print(parsed_data['raw_text'])
    except Exception as exc:
        logging.error("Failed to process %s: %s", args.image_path, exc)

if __name__ == "__main__":
    main()
