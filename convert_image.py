import os
from PIL import Image

def process_image(input_folder, output_folder):
    # Ensure output folder exists
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    # Iterate over all files in the input folder
    for file in os.listdir(input_folder):
        if file.endswith(".bmp"):
            file_path = os.path.join(input_folder, file)
            output_file_path = os.path.join(output_folder, os.path.splitext(file)[0] + '.txt')

            # Open the image
            with Image.open(file_path) as img:
                width, height = img.size
                # Open the output text file
                with open(output_file_path, 'w') as txt_file:
                    # Process each pixel
                    for y in range(height):
                        line = ""
                        for x in range(width):
                            pixel = img.getpixel((x, y))
                            # Check if the pixel is white (#fff)
                            if pixel == (255, 255, 255):
                                line += "0"
                            else:
                                line += "1"
                        line = line[::-1]
                        # Write the line to the text file
                        txt_file.write(line + '\n')

# Example usage
input_folder = 'bmp_images'
output_folder = 'images'
process_image(input_folder, output_folder)
