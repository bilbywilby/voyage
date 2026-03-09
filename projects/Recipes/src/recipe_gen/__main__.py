# src/recipe_gen/__main__.py - CLI Entry Point
import sys
import json
import os
import logging
import argparse
import shutil
from pathlib import Path

# --- Core Local Imports from the Beta Pipeline ---
from recipe_gen.ocr_pipeline import (
    image_to_text,
    parse_raw_text,
    create_recipe_card,
    recipe_to_dict,
    generate_filename_prefix,
    save_original_image,
    _OCR_AVAILABLE,
)

# --- Configuration ---
log = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")

# --- Main CLI Logic ---
def main() -> None:
    """
    The main command-line interface logic for the Recipe Card Generator.
    Handles argument parsing, pipeline execution, and atomic file output.
    """
    parser = argparse.ArgumentParser(
        description="OCR Recipe Card Generator: Ingests an image and outputs structured JSON or HTML."
    )
    parser.add_argument(
        "image", 
        type=Path, 
        help="Path to the recipe image file (e.g., photo of a handwritten card)."
    )
    parser.add_argument(
        "--no-preprocess", 
        action="store_true", 
        help="Skip OpenCV image enhancement (faster, but potentially lower OCR accuracy)."
    )
    parser.add_argument(
        "--output-file",
        type=Path,
        default=None,
        help="Explicit path to save the output. If omitted, a name is generated from the recipe title.",
    )
    parser.add_argument("--pretty", action="store_true", help="Pretty-print JSON output with 2-space indentation.")
    parser.add_argument("--card", action="store_true", help="Render a styled HTML recipe card instead of JSON.")
    parser.add_argument(
        "--copy-original", 
        action="store_true", 
        help="Copy the original image to the output directory."
    )
    args = parser.parse_args()

    # --- Pre-flight Checks ---
    if not args.image.is_file():
        log.error(f"Image path missing or invalid: {args.image}")
        sys.exit(1)

    if not _OCR_AVAILABLE:
        log.error("Tesseract OCR executable not found. Install Tesseract and ensure it is in your system PATH.")
        sys.exit(1)

    try:
        log.info(f"Starting OCR and parsing for: {args.image.name}")
        
        # 1. OCR Step
        raw_text = image_to_text(str(args.image), preprocess=not args.no_preprocess)
        
        # 2. Parsing Step (returns the structured Recipe object)
        recipe = parse_raw_text(raw_text)

        # 3. Filename Automation/Determination
        output_path: Path = args.output_file
        if output_path is None:
            ext = ".html" if args.card else ".json"
            prefix = generate_filename_prefix(recipe.title or "recipe")
            
            output_path = args.image.parent / f"{prefix}{ext}"
            log.info(f"No output file supplied – using generated name: {output_path.name}")
        
        # Ensure parent directory exists before writing
        output_path.parent.mkdir(parents=True, exist_ok=True)

        # 4. Build output content
        if args.card:
            output_content = create_recipe_card(recipe)
        else:
            out_dict = recipe_to_dict(recipe)
            indent = 2 if args.pretty else None
            output_content = json.dumps(out_dict, ensure_ascii=False, indent=indent)

        # 5. Atomic Write
        tmp_path = output_path.with_suffix(output_path.suffix + ".tmp")
        tmp_path.write_text(output_content, encoding="utf-8")
        os.replace(tmp_path, output_path)
        log.info(f"✅ Digital recipe successfully saved to: {output_path.resolve()}")

        # 6. Optional Image Copy
        if args.copy_original:
            try:
                save_original_image(str(args.image), str(output_path.parent))
                log.info(f"📁 Original image copied to {output_path.parent.resolve()}")
            except Exception as e:
                log.warning(f"Failed to copy original image: {e}")

    except Exception as exc:
        if 'tmp_path' in locals() and tmp_path.exists():
            tmp_path.unlink()
        log.exception(f"Processing failed: {exc}")
        sys.exit(1)

if __name__ == "__main__":
    main()
