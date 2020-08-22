# cacher.py
# Naim Sen
# 04/2020

import os
import glob
import shutil
import atexit
from pathlib import Path
from PIL import Image, ImageFilter

def cleanup():
    shutil.rmtree(temp_dir)
    print("Exiting")

temp_dir = Path(f"{os.getenv('temp')}/SpotlightCache")
spotlight_assets = Path(f"{os.getenv('localappdata')}/Packages/Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy/LocalState/Assets")
wallpapers_dir = Path("C:/Users/naimk/OneDrive/Pictures/Spotlight Papers")

for filename in glob.glob(str(spotlight_assets/"*")):
    filename = Path(filename)
    img = Image.open(filename)
    width, height = img.size
    if width == 1920 and height == 1080:
        unblurred_path = (wallpapers_dir/"org"/filename.name).with_suffix('.jpg')
        blurred_path = (wallpapers_dir/"blur"/(filename.name+"_blur")).with_suffix('.jpg')
        shutil.copy(filename, unblurred_path)
        img_blurred = img.filter(ImageFilter.GaussianBlur(radius=10))
        img_blurred.save(blurred_path)

# for filename in glob.glob(str(wallpapers_dir/"*.*")):
#     filename = Path(filename)
#     img = Image.open(filename)
#     blurred_path = (wallpapers_dir/"blur"/(filename.name+"_blur")).with_suffix(filename.suffix)
#     # shutil.copy(filename, unblurred_path)
#     img_blurred = img.filter(ImageFilter.GaussianBlur(radius=10))
#     img_blurred.save(blurred_path)