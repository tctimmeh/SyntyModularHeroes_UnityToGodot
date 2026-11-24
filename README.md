# Synty Modular Hero Characters from Unity to Godot

Based on work found here: https://www.youtube.com/watch?v=nasSGwC6ef4

## Extract from Unity

- Create/Open a Unity project
- Open the Package Managera (Window -> Package Management -> Package Manager)
- Select "My Assets" under "Sources" in the left pane
- Find the Modular Fantasy Hero Characters Pack and click the Download button
- Copy the path to the downloaded .unitypackage file
    - Linux: `~/.local/share/unity3d/Asset Store/.../*.unitypackage
- Use python lib "unitypackage_extractor" to unpack the unity package
    - e.g.:
```
mkdir /tmp/extract
cd /tmp/extract
python -m venv venv
. venv/bin/activate
pip install unitypackage_extractor
cp ~/.local/share/unity3d/.../Characters.unitypackage characters.unitypackage
python -m unitypackage_extractor characters.unitypackage /tmp/wotwot/
```
## Prepare in Blender

### Load the Files

- Start a new project, delete the default cube, camera, light, and collection
- Create a "Characters" collection and select it
- File -> Import -> Fbx (Legacy)
    - Choose the "FixedScale" character .fbx file
    - Animation: OFF
    - Armature:
        - Ignore Leaf Bones: ON
        - Force Connect Children: ON
        - Automatic Bone Orientation: ON
- Create a "Weapons" collection and select it
- File -> Import -> Fbx (Legacy)
    - Select all the weapons .fbx files
    - Same settings as characters import

### Fix & Organize Weapons

- Create an Empty object called "Weapons" in the Weapons collection and parent all the weapons to it
    - Select the "Weapons" collection
    - In 3D viewport, Add -> Empty -> Plain Axes
    - Rename it to Weapons
    - Select all the Weapons then Ctrl-click the "Weapons" empty so it is active
    - In 3D viewport, Object -> Parent -> Object

#### Some weapons are in a far-off place - bring them to the origin

- In 3D viewport, Object -> Snap -> Cursor to World Origin
- Select all the weapons (all objects in Weapons collection)
    - In 3D viewport, Object -> Set Origin -> Origin to Geometry
    - In 3D viewport, Object -> Snap -> Selection to Cursor

### If you want the materials variations

- Create a Materials collection and select it
- Create 12 planes with unique copies of the ModularHero_01 material
    - With their textures set to the 0[123]_[ABC] texture variants
- Create a "Materials" empty and parent all the planes to it

### Final fix-ups

- Go to Scripting view, load the `blender_prepare.py` file and execute it
- This does:
    - Gives objects better names
        - Useless Modular_Characters tree is removed
        - Default material gets a more useful name, ModularHero_01
        - Meshes are named to match their objects and prefixes removed
        - Hero armature is renamed to ModularHero
        - Male leg swap is fixed
        - All objects get the default material
        - All transforms applied

### Export

- File -> Export -> gltf
    - Transform -> +Y Up: ON
    - Data -> Mesh
        - UVs: ON
        - Normals: ON
        - Vertex Colors: NONE
    - Animation: OFF

## Import to Godot

- Copy the `.gd` and `.tres` files to the Godot project
- Move the .glb file exported from blender into the Godot project
- Open the .glb file
    - Actions -> Extract Materials
    - Load the `synty_bone_map.tres` file onto the ModularHero/Skeleton3D node
    - Load the `modular_hero_import.gd` as the import script on the top-level node
    - Click Reimport

