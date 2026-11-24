@tool
extends EditorScenePostImport

const ModularHeroMeshes = preload("./modular_hero_meshes.gd")

var source_dir: String

func _post_import(scene: Node) -> Object:
    source_dir = get_source_file().get_base_dir()
    prints("IMPORTING POLYGON FANTASY HEROES at", source_dir)

    scene.remove_child(scene.find_child("Materials"))
    
    create_weapon_scenes(scene)
    setup_character_meshes(scene)
    
    return scene

func create_weapon_scenes(scene: Node):
    var lib_dir = DirAccess.open(source_dir)
    if not lib_dir.dir_exists("weapons"):
        lib_dir.make_dir("weapons")
    
    var weapons_node = scene.find_child("Weapons")
    var weapons_path = source_dir.path_join("weapons")
    
    var num_skipped := 0
    for child in weapons_node.get_children():
        var weapon_scene_path = weapons_path.path_join(child.name + ".tscn")
        if ResourceLoader.exists(weapon_scene_path):
            num_skipped += 1
            continue

        var packed_scene: PackedScene = PackedScene.new()
        packed_scene.pack(child)
        ResourceSaver.save(packed_scene, weapon_scene_path)

    prints(" - Created Weapon scenes at", weapons_path)
    if num_skipped:
        prints("   - Skipped", num_skipped, "existing weapon scenes. Remove them to re-import.")
    scene.remove_child(weapons_node)

func setup_character_meshes(scene: Node):
    var hero := scene.find_child("ModularHero")
    var skeleton := scene.find_child("GeneralSkeleton")

    # Re-parent the skeleton to the scene and throw away the empty node
    skeleton.owner = null
    hero.remove_child(skeleton)
    scene.add_child(skeleton)
    skeleton.owner = scene
    scene.remove_child(hero)

    var lib_dir = DirAccess.open(source_dir)
    if not lib_dir.dir_exists("meshes"):
        lib_dir.make_dir("meshes")
    var meshes_path = source_dir.path_join("meshes")

    var slot_regex = RegEx.new()
    slot_regex.compile(r"^(.*?)_\d+$")

    # catalog the slot names, without the Male/Female, into a resource file
    var meshes = ModularHeroMeshes.new()
    for child in skeleton.get_children():
        var slot_name = child.name\
            .replace("Male_", "")\
            .replace("Female_", "")\
            .replace("Ear_Ear_", "Ear_")
        var m = slot_regex.search(slot_name)
        slot_name = m.strings[1]
        if not meshes.slots.has(slot_name):
            meshes.slots[slot_name] = []
        var form = "n"
        if child.name.contains("Male_"):
            form = "m"
        if child.name.contains("Female_"):
            form = "f"
        meshes.slots[slot_name].append({"mesh": child.name, "form": form})
        ResourceSaver.save(child.mesh, meshes_path.path_join(child.name + ".res"))
    ResourceSaver.save(meshes, source_dir.path_join("modular_hero_meshes.res"))
    
    # remove all the existing mesh instances and create a new one for each slot from a saved prototype
    var slot_prototype = skeleton.get_children()[0]
    slot_prototype.mesh = null
    for child in skeleton.get_children():
        skeleton.remove_child(child)
    for slot_name in meshes.slots:
        var slot_node = slot_prototype.duplicate()
        slot_node.name = slot_name
        skeleton.add_child(slot_node)
        slot_node.owner = scene
    
    var hero_script := load(source_dir.path_join("modular_hero.gd"))
    scene.set_script(hero_script)
    
    prints(" - Created character meshes for slots:")
    for name in meshes.slots:
        prints("   -", name, ":", meshes.slots[name].size())
