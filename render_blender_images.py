import bpy
import os

# Array of properties to render
data = [
    {'animation': 'running', 'start': 1,'end': 39, 'step': 2},
    {'animation': 'attacking', 'start': 182,'end': 220, 'step': 2},
    {'animation': 'dying', 'start': 262,'end': 319, 'step': 3}
]

# Set the number of degrees to decrease the rotation by
rotation_step = 18
# Set the number of degrees to create a new folder
folder_step = 90

# Set up rendering parameters (you can customize these as needed)
render_settings = bpy.context.scene.render
render_settings.resolution_x = 320  # Set X resolution
render_settings.resolution_y = 320  # Set Y resolution

# Get the current working directory
base_path = "/media/Data/codebase/factorio/here-be-dragons/working/animation/"

# Set the number of frames for the animation (360 / rotation_step)
rotation_count = int(360 / rotation_step)

# Get the object
obj = bpy.data.objects.get("dragon")

# Loop through animations

for prop in data:

    # Reset rotation
    obj.rotation_euler.z = 0
        
    # Loop through each frame
    for frame_num in range(rotation_count):
        # Check if it's time to create a new folder
        if frame_num % (folder_step / rotation_step) == 0:
            folder_name = f"angle_{(frame_num*rotation_step)}"
            folder_path = os.path.join(base_path, prop['animation'], folder_name)
            os.makedirs(folder_path, exist_ok=True)
        
        # Set output file name
        img_name = f"image_{(frame_num*rotation_step):03d}_###"
        render_settings.filepath = os.path.join(folder_path, img_name)
        
        # Set start/end frames
        bpy.context.scene.frame_start = prop['start']
        bpy.context.scene.frame_end = prop['end']
        bpy.context.scene.frame_step = prop['step']

        # Render the animation
        bpy.ops.render.render(animation=True)
        
        # Decrease the rotation for the next frame sequence
        obj.rotation_euler.z -= rotation_step * (3.14159 / 180)
    