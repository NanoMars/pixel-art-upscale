import os
from PIL import Image

def upscale_image(image_path, output_path, scale=3):
    image = Image.open(image_path)
    image = image.resize((image.width * scale, image.height * scale), Image.NEAREST)
    
    # Save the upscaled image
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    image.save(output_path)

def process_folder(input_folder, output_folder, scale=3):
    # Create input_folder and output_folder if they do not exist
    os.makedirs(input_folder, exist_ok=True)
    os.makedirs(output_folder, exist_ok=True)
    
    for root, _, files in os.walk(input_folder):
        for file in files:
            if file.lower().endswith(('.png', '.jpg', '.jpeg', '.bmp', '.gif')):
                from_path = os.path.join(root, file)
                to_path = from_path.replace(input_folder, output_folder)
                upscale_image(from_path, to_path, scale)

if __name__ == "__main__":
    input_folder = "input_images"
    output_folder = "upscaled_images"
    process_folder(input_folder, output_folder)