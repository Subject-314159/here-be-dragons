import bpy
import os

# The function that actually renders given object
def render(base_path, obj):
    # Remove the directory
    try:
        os.rmdir(base_path)
    except Exception as e:
        print(f"Error: {e}")

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

    # Set the number of frames for the animation (360 / rotation_step)
    rotation_count = int(360 / rotation_step)

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

    
# Set up rendering parameters
render_settings = bpy.context.scene.render
render_settings.resolution_x = 500  # Set X resolution
render_settings.resolution_y = 500  # Set Y resolution

# Get the world & background node
world_nodes = bpy.context.scene.world.node_tree
background_node = world_nodes.nodes.get('Background')

# Get the objects
obj = bpy.data.objects.get("dragon")
objs = bpy.data.objects.get("dragon-shadow")
plane = bpy.data.objects.get("Plane")
lmp = bpy.data.objects.get("Light")
cam = bpy.data.objects.get('Camera')

# First render only the dragon without shadow
bpy.context.scene.render.engine = 'BLENDER_EEVEE'
background_node.inputs['Strength'].default_value = 1.0
cam.location.x = 0.0
base_path = "/media/Data/codebase/factorio/here-be-dragons/working/animation/"
obj.hide_render = False
objs.hide_render = True
plane.hide_render = True
lmp.hide_render = True
render(base_path, obj)

# Next render only the shadow
bpy.context.scene.render.engine = 'CYCLES'
background_node.inputs['Strength'].default_value = 1.0
cam.location.x = -0.2
base_path = "/media/Data/codebase/factorio/here-be-dragons/working/shadow/"
obj.hide_render = True
objs.hide_render = False
plane.hide_render = False
lmp.hide_render = False
render(base_path, objs)