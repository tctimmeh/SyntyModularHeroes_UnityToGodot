import bpy

# https://blender.stackexchange.com/a/272730
def delete_hierarchy(parent_obj_name):
    bpy.ops.object.select_all(action='DESELECT')
    obj = bpy.data.objects[parent_obj_name]
    obj.animation_data_clear()
    names = set()
    # Go over all the objects in the hierarchy like @zeffi suggested:
    def get_child_names(obj):
        for child in obj.children:
            names.add(child.name)
            if child.children:
                get_child_names(child)
    get_child_names(obj)
    names.add(parent_obj_name)
    objects = bpy.data.objects
    # Remove the animation from the all the child objects
    if names:
        for child_name in names:
            bpy.data.objects[child_name].animation_data_clear()
            objects[child_name].select_set(state=True)
            bpy.data.objects.remove(objects[child_name])

# Remove the ModularCharacters series of empty objects
delete_hierarchy('Modular_Characters')

# Give the default material a useful name
default_material = bpy.data.materials['lambert2']
default_material.name = "ModularHero_01"

# Give the character a useful name
bpy.data.objects['Armature'].name = "ModularHero"

# Fix the left/right male leg swap
for obj in bpy.data.objects:
    if obj.type == 'MESH':
        if obj.name.startswith('Chr_LegLeft_Male_'):
            obj.name = 'Fixed' + obj.name.replace('LegLeft', 'LegRight')
        elif obj.name.startswith('Chr_LegRight_Male_'):
            obj.name = 'Fixed' + obj.name.replace('LegRight', 'LegLeft')
for obj in bpy.data.objects:
    if obj.type == 'MESH':
        if obj.name.startswith('Fixed'):
            obj.name = obj.name[5:]

# Rename Meshes to be the same as their parent MeshObjects
for obj in bpy.data.objects:
    if obj.type == 'MESH':
        if obj.name.startswith('Chr_'):
            obj.name = obj.name[4:]
        if obj.name.startswith('SM_Wep_'):
            obj.name = obj.name[7:]
        obj.data.name = obj.name

# Set all materials to the default material
for obj in bpy.data.objects:
    if obj.type != "MESH":
        continue
    for slot in obj.material_slots:
        slot.material = default_material

# Apply transforms
for obj in bpy.data.objects:
    obj.select_set(True)
bpy.ops.object.transform_apply(location=True, rotation=True, scale=True)

