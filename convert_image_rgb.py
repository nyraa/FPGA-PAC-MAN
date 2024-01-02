import os
from PIL import Image

def process_image(input_folder, output_folder):
    # Ensure output folder exists
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    # Iterate over all files in the input folder
    for file in os.listdir(input_folder):
        if file.endswith(".bmp"):
            if not file == 'game_over.bmp':
                continue
            file_path = os.path.join(input_folder, file)
            output_file_path = os.path.join(output_folder, os.path.splitext(file)[0] + '_r.txt')

            # Open the image
            with Image.open(file_path) as img:
                width, height = img.size
                # Open the output text file
                with open(output_file_path, 'w') as txt_file_r:
                    txt_file_g = open(output_file_path.replace('_r.txt', '_g.txt'), 'w')
                    txt_file_b = open(output_file_path.replace('_r.txt', '_b.txt'), 'w')
                    # Process each pixel
                    for y in range(height):
                        line_r = ""
                        line_g = ""
                        line_b = ""
                        for x in range(width):
                            pixel = img.getpixel((x, y))
                            line_r += (pixel[0]//16).__format__('x')
                            line_g += (pixel[1]//16).__format__('x')
                            line_b += (pixel[2]//16).__format__('x')

                        # reverse the string
                        line_r = line_r[::-1]
                        line_g = line_g[::-1]
                        line_b = line_b[::-1]
                        # Write the line to the text file
                        txt_file_r.write(line_r + '\n')
                        txt_file_g.write(line_g + '\n')
                        txt_file_b.write(line_b + '\n')

# Example usage
input_folder = 'bmp_images'
output_folder = 'images_rgb'
process_image(input_folder, output_folder)
