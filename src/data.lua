-- Animations
local walking = {
    layers = {{
        filenames = {"__here-be-dragons__/graphics/entity/dragon/dragon_running_0.png",
                     "__here-be-dragons__/graphics/entity/dragon/dragon_running_1.png",
                     "__here-be-dragons__/graphics/entity/dragon/dragon_running_2.png",
                     "__here-be-dragons__/graphics/entity/dragon/dragon_running_3.png"},
        direction_count = 20,
        lines_per_file = 10,
        slice = 10,
        frame_count = 20,
        size = 500,
        shift = {0.15, -1.2}
        -- scale = 1.5
    }, {
        filenames = {"__here-be-dragons__/graphics/entity/dragon/dragon_running_shadow_0.png",
                     "__here-be-dragons__/graphics/entity/dragon/dragon_running_shadow_1.png",
                     "__here-be-dragons__/graphics/entity/dragon/dragon_running_shadow_2.png",
                     "__here-be-dragons__/graphics/entity/dragon/dragon_running_shadow_3.png"},
        direction_count = 20,
        lines_per_file = 10,
        slice = 10,
        frame_count = 20,
        size = 500,
        shift = {1.15, -1.2},
        -- scale = 1.5,
        draw_as_shadow = true
    }}
}
local attacking = {
    layers = {{
        filenames = {"__here-be-dragons__/graphics/entity/dragon/dragon_attacking_0.png",
                     "__here-be-dragons__/graphics/entity/dragon/dragon_attacking_1.png",
                     "__here-be-dragons__/graphics/entity/dragon/dragon_attacking_2.png",
                     "__here-be-dragons__/graphics/entity/dragon/dragon_attacking_3.png"},
        direction_count = 20,
        lines_per_file = 10,
        slice = 10,
        frame_count = 20,
        size = 500,
        shift = {0.15, -1.2}
        -- scale = 1.5
    }, {
        filenames = {"__here-be-dragons__/graphics/entity/dragon/dragon_attacking_shadow_0.png",
                     "__here-be-dragons__/graphics/entity/dragon/dragon_attacking_shadow_1.png",
                     "__here-be-dragons__/graphics/entity/dragon/dragon_attacking_shadow_2.png",
                     "__here-be-dragons__/graphics/entity/dragon/dragon_attacking_shadow_3.png"},
        direction_count = 20,
        lines_per_file = 10,
        slice = 10,
        frame_count = 20,
        size = 500,
        shift = {1.15, -1.2},
        draw_as_shadow = true
    }}
}
local dying = {
    layers = {{
        -- filename = "__here-be-dragons__/graphics/entity/dragon/dragon_dying_0.png",
        filenames = {"__here-be-dragons__/graphics/entity/dragon/dragon_dying_0.png",
                     "__here-be-dragons__/graphics/entity/dragon/dragon_dying_1.png",
                     "__here-be-dragons__/graphics/entity/dragon/dragon_dying_2.png",
                     "__here-be-dragons__/graphics/entity/dragon/dragon_dying_3.png"},
        direction_count = 20,
        lines_per_file = 10,
        line_length = 10,
        slice = 10,
        frame_count = 20,
        size = 500,
        shift = {0.15, -1.2}
    }, {
        -- filename = "__here-be-dragons__/graphics/entity/dragon/dragon_dying_0.png",
        filenames = {"__here-be-dragons__/graphics/entity/dragon/dragon_dying_shadow_0.png",
                     "__here-be-dragons__/graphics/entity/dragon/dragon_dying_shadow_1.png",
                     "__here-be-dragons__/graphics/entity/dragon/dragon_dying_shadow_2.png",
                     "__here-be-dragons__/graphics/entity/dragon/dragon_dying_shadow_3.png"},
        direction_count = 20,
        lines_per_file = 10,
        line_length = 10,
        slice = 10,
        frame_count = 20,
        size = 500,
        shift = {0.15, -1.2},
        draw_as_shadow = true
    }}
}

-- Entity prototype
local pcp = {}
for o = 0, 1, 0.0625 do
    local r = 5
    local rad = (o - 0.25) * 2 * math.pi
    local x = r * math.cos(rad)
    local y = r * math.sin(rad)
    local prop = {
        orientation = o,
        shift = {x, y}
    }
    table.insert(pcp, prop)
    log("Offset vector: " .. o .. " {" .. x .. "," .. y .. "}")
end
local dragon = table.deepcopy(data.raw["unit"]["big-spitter"])
dragon.name = "dragon"
dragon.icon = "__here-be-dragons__/graphics/icon/dragon/dragon.png"
dragon.icon_size = 128
dragon.icon_mipmaps = 1
dragon.run_animation = walking
dragon.movement_speed = (28.9 / 3.6 / 60)
local att = dragon.attack_parameters
att.animation = attacking
att.range = 19
att.warmup = 30
att.cooldown = 60
att.lead_target_for_projectile_speed = 1
att.ammo_type.category = "flamethrower"
att.ammo_type.action.action_delivery.stream = "dragon-fire-stream"
att.projectile_creation_parameters = pcp
att.cyclic_sound.begin_sound.filename = "__here-be-dragons__/sounds/fire.ogg"
att.cyclic_sound.middle_sound = nil
att.cyclic_sound.end_sound.filename = "__here-be-dragons__/sounds/fire-end-alt.ogg"
dragon.dying_explosion = "dragon-die"
dragon.corpse = "dragon-corpse"
dragon.alternative_attacking_frame_sequence = {
    warmup_frame_sequence = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12},
    warmup2_frame_sequence = {12},
    prepared_frame_sequence = {12},
    attacking_frame_sequence = {13, 14, 15, 16},
    cooldown_frame_sequence = {15, 14, 13},
    back_to_walk_frame_sequence = {17, 18, 19, 20},
    warmup_animation_speed = 0.1,
    attacking_animation_speed = 0.02,
    cooldown_animation_speed = 0.02,
    prepared_animation_speed = 0.02,
    back_to_walk_animation_speed = 0.035
}
dragon.resistances = {{
    type = "acid",
    decrease = 5,
    percent = 70
}, {
    type = "explosion",
    decrease = 50,
    percent = 85
}, {
    type = "fire",
    decrease = 100,
    percent = 100
}, {
    type = "laser",
    decrease = 12,
    percent = 45
}, {
    type = "physical",
    decrease = 24,
    percent = 60
}, {
    type = "poison",
    decrease = 3,
    percent = 20
}}
dragon.max_health = 8000
dragon.healing_per_tick = 1.5

-- Dying explostion prototype
local die = table.deepcopy(data.raw["explosion"]["big-spitter-die"])
die.name = "dragon-die"
die.localised_name = {"hbd.dragon-die", "dying-explosion-name", "entity-name.dragon-die"}

-- Corpse prototype
local corpse = table.deepcopy(data.raw["corpse"]["big-spitter-corpse"])
corpse.name = "dragon-corpse"
corpse.animation = dying

-- Stream prototype
local stream = table.deepcopy(data.raw["stream"]["flamethrower-fire-stream"])
stream.name = "dragon-fire-stream"
stream.particle_spawn_interval = 1
stream.particle_spawn_timeout = 30
stream.action[1] = table.deepcopy(stream.action[2])
local eff = stream.action[1].action_delivery.target_effects[1]
eff.entity_name = "dragon-fire-flame"
eff.offset_deviation = {{-2, -2}, {2, 2}}
stream.action[2] = nil
-- stream.action[2].action_delivery.target_effects[1].entity_name = "dragon-fire-flame"
-- stream.action[1].action_delivery.target_effects[2] = nil -- .damage.amount = 0

-- Flame prototype
local cmask = table.deepcopy(data.raw["fire"]["acid-splash-fire-worm-small"].on_damage_tick_effect.collision_mask)
local flame = table.deepcopy(data.raw["fire"]["fire-flame"])
flame.name = "dragon-fire-flame"
flame.damage_per_tick.amount = 0
flame.on_damage_tick_effect = {
    type = "direct",
    filter_enabled = true,
    action_delivery = {
        type = "instant",
        target_effects = {
            type = "damage",
            damage = {
                amount = 0.02,
                type = "fire"
            }
        }
    },
    collision_mask = cmask,
    force = "enemy"
}

-- Add our data
data:extend({dragon, die, corpse, stream, flame})

-- Update the spawner
local spawner = data.raw["unit-spawner"]["spitter-spawner"]
local res = spawner.result_units
local spawn = {
    unit = "dragon",
    spawn_points = {{
        evolution_factor = 0,
        spawn_weight = 0
    }, {
        evolution_factor = 0.9,
        spawn_weight = 0
    }, {
        evolution_factor = 1,
        spawn_weight = 1
    }}
}

if res then
    table.insert(res, spawn)
else
    res = {spawn}
end

-- Add dragon-only spawner (for testing)
-- local ds = table.deepcopy(spawner)
-- ds.name = "dragon-spawner"
-- ds.result_units = {spawn}

-- data:extend({ds})
