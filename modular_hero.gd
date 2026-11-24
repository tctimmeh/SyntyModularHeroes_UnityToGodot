@tool
extends Node3D

const mesh_slots = preload("./modular_hero_meshes.res")
@onready var skeleton := %GeneralSkeleton

@export_group("Parts")
@export_range(-1, 37) var arm_lower_left: int = -1: set = _set_arm_lower_left
@export_range(-1, 37) var arm_lower_right: int = -1: set = _set_arm_lower_right
@export_range(-1, 41) var arm_upper_left: int = -1: set = _set_arm_upper_left
@export_range(-1, 41) var arm_upper_right: int = -1: set = _set_arm_upper_right
@export_range(-1, 2) var ear: int = -1: set = _set_ear
@export_range(-1, 35) var hand_left: int = -1: set = _set_hand_left
@export_range(-1, 35) var hand_right: int = -1: set = _set_hand_right
@export_range(-1, 45) var head: int = -1: set = _set_head
@export_range(-1, 25) var head_no_elements: int = -1: set = _set_head_no_elements
@export_range(-1, 57) var hips: int = -1: set = _set_hips
@export_range(-1, 39) var leg_left: int = -1: set = _set_leg_left
@export_range(-1, 39) var leg_right: int = -1: set = _set_leg_right
@export_range(-1, 57) var torso: int = -1: set = _set_torso
@export_range(-1, 16) var eyebrow: int = -1: set = _set_eyebrow
@export_range(-1, 17) var facial_hair: int = -1: set = _set_facial_hair
@export_range(-1, 37) var hair: int = -1: set = _set_hair
@export_range(-1, 14) var back_attachment: int = -1: set = _set_back_attachment
@export_range(-1, 5) var elbow_attach_left: int = -1: set = _set_elbow_attach_left
@export_range(-1, 5) var elbow_attach_right: int = -1: set = _set_elbow_attach_right
@export_range(-1, 10) var head_coverings_base_hair: int = -1: set = _set_head_coverings_base_hair
@export_range(-1, 3) var head_coverings_no_facial_hair: int = -1: set = _set_head_coverings_no_facial_hair
@export_range(-1, 12) var head_coverings_no_hair: int = -1: set = _set_head_coverings_no_hair
@export_range(-1, 12) var helmet_attachment: int = -1: set = _set_helmet_attachment
@export_range(-1, 11) var hips_attachment: int = -1: set = _set_hips_attachment
@export_range(-1, 10) var knee_attach_left: int = -1: set = _set_knee_attach_left
@export_range(-1, 10) var knee_attach_right: int = -1: set = _set_knee_attach_right
@export_range(-1, 20) var shoulder_attach_left: int = -1: set = _set_shoulder_attach_left
@export_range(-1, 20) var shoulder_attach_right: int = -1: set = _set_shoulder_attach_right

func _ready() -> void:
    arm_lower_left = arm_lower_left
    arm_lower_right = arm_lower_right
    arm_upper_left = arm_upper_left
    arm_upper_right = arm_upper_right
    ear = ear
    hand_left = hand_left
    hand_right = hand_right
    head = head
    head_no_elements = head_no_elements
    hips = hips
    leg_left = leg_left
    leg_right = leg_right
    torso = torso
    eyebrow = eyebrow
    facial_hair = facial_hair
    hair = hair
    back_attachment = back_attachment
    elbow_attach_left = elbow_attach_left
    elbow_attach_right = elbow_attach_right
    head_coverings_base_hair = head_coverings_base_hair
    head_coverings_no_facial_hair = head_coverings_no_facial_hair
    head_coverings_no_hair = head_coverings_no_hair
    helmet_attachment = helmet_attachment
    hips_attachment = hips_attachment
    knee_attach_left = knee_attach_left
    knee_attach_right = knee_attach_right
    shoulder_attach_left = shoulder_attach_left
    shoulder_attach_right = shoulder_attach_right

func set_mesh(slot_name: String, idx: int) -> void:
    if not is_inside_tree():
        return
    
    var slot_node = skeleton.find_child(slot_name)
    if idx < 0:
        slot_node.mesh = null
        return

    var mesh_list = mesh_slots.slots[slot_name]
    if idx >= mesh_list.size():
        push_warning("Mesh index out of bounds for " + slot_name + ", max " + str(mesh_list.size() - 1))
        return
    var mesh_info = mesh_list[idx]
    var mesh_file = get_script().get_path().get_base_dir().path_join("meshes").path_join(mesh_info["mesh"] + ".res")
    slot_node.mesh = load(mesh_file)

func _set_arm_lower_left(new_value: int) -> void:
    arm_lower_left = new_value
    set_mesh("ArmLowerLeft", new_value)

func _set_arm_lower_right(new_value: int) -> void:
    arm_lower_right = new_value
    set_mesh("ArmLowerRight", new_value)

func _set_arm_upper_left(new_value: int) -> void:
    arm_upper_left = new_value
    set_mesh("ArmUpperLeft", new_value)

func _set_arm_upper_right(new_value: int) -> void:
    arm_upper_right = new_value
    set_mesh("ArmUpperRight", new_value)

func _set_back_attachment(new_value: int) -> void:
    back_attachment = new_value
    set_mesh("BackAttachment", new_value)

func _set_ear(new_value: int) -> void:
    ear = new_value
    set_mesh("Ear", new_value)

func _set_elbow_attach_left(new_value: int) -> void:
    elbow_attach_left = new_value
    set_mesh("ElbowAttachLeft", new_value)

func _set_elbow_attach_right(new_value: int) -> void:
    elbow_attach_right = new_value
    set_mesh("ElbowAttachRight", new_value)

func _set_eyebrow(new_value: int) -> void:
    eyebrow = new_value
    set_mesh("Eyebrow", new_value)

func _set_hair(new_value: int) -> void:
    hair = new_value
    set_mesh("Hair", new_value)

func _set_facial_hair(new_value: int) -> void:
    facial_hair = new_value
    set_mesh("FacialHair", new_value)

func _set_hand_left(new_value: int) -> void:
    hand_left = new_value
    set_mesh("HandLeft", new_value)

func _set_hand_right(new_value: int) -> void:
    hand_right = new_value
    set_mesh("HandRight", new_value)

func _set_head(new_value: int) -> void:
    head = new_value
    set_mesh("Head", new_value)

func _set_head_no_elements(new_value: int) -> void:
    head_no_elements = new_value
    set_mesh("Head_No_Elements", new_value)

func _set_head_coverings_base_hair(new_value: int) -> void:
    head_coverings_base_hair = new_value
    set_mesh("HeadCoverings_Base_Hair", new_value)

func _set_head_coverings_no_facial_hair(new_value: int) -> void:
    head_coverings_no_facial_hair = new_value
    set_mesh("HeadCoverings_No_FacialHair", new_value)

func _set_head_coverings_no_hair(new_value: int) -> void:
    head_coverings_no_hair = new_value
    set_mesh("HeadCoverings_No_Hair", new_value)

func _set_helmet_attachment(new_value: int) -> void:
    helmet_attachment = new_value
    set_mesh("HelmetAttachment", new_value)

func _set_hips(new_value: int) -> void:
    hips = new_value
    set_mesh("Hips", new_value)

func _set_hips_attachment(new_value: int) -> void:
    hips_attachment = new_value
    set_mesh("HipsAttachment", new_value)

func _set_knee_attach_left(new_value: int) -> void:
    knee_attach_left = new_value
    set_mesh("KneeAttachLeft", new_value)

func _set_knee_attach_right(new_value: int) -> void:
    knee_attach_right = new_value
    set_mesh("KneeAttachRight", new_value)

func _set_leg_left(new_value: int) -> void:
    leg_left = new_value
    set_mesh("LegLeft", new_value)

func _set_leg_right(new_value: int) -> void:
    leg_right = new_value
    set_mesh("LegRight", new_value)

func _set_shoulder_attach_left(new_value: int) -> void:
    shoulder_attach_left = new_value
    set_mesh("ShoulderAttachLeft", new_value)

func _set_shoulder_attach_right(new_value: int) -> void:
    shoulder_attach_right = new_value
    set_mesh("ShoulderAttachRight", new_value)

func _set_torso(new_value: int) -> void:
    torso = new_value
    set_mesh("Torso", new_value)
