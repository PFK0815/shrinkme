local mcl_core = minetest.get_modpath("mcl_core") ~= nil
local sizes = {}

local function size(player, param)
    entity_modifier.resize_player(player, param)
end

minetest.register_on_joinplayer(function(player)
    sizes[player:get_player_name()] = 1
    if mcl_core then
        playerphysics.add_physics_factor(player, "speed", "shrinkme:speed", 1)
    end
end)

minetest.register_on_leaveplayer(function(player)
    sizes[player:get_player_name()] = nil
end)

minetest.register_craftitem("shrinkme:shrinker", {
    description = "Shrinker (Size/2)",
    inventory_image = "smallersize.png",
    on_use = function(itemstack, player, pointed_thing)
        local playername = player:get_player_name()
        if sizes[playername] ~= 1/16 then
            size(player, sizes[playername] / 2);
            sizes[playername] = sizes[playername] / 2
        end
    end
});

minetest.register_craftitem("shrinkme:grower", {
    description = "Grower (Size*2)",
    inventory_image = "biggersize.png",
    on_use = function(itemstack, player, pointed_thing)
        local playername = player:get_player_name()
        if sizes[playername] ~= 1*16 then
            size(player, sizes[playername] * 2);
            sizes[playername] = sizes[playername] * 2
        end
    end
});

minetest.register_craftitem("shrinkme:reset", {
    description = "Reseter",
    inventory_image = "resetsize.png",
    on_use = function(itemstack, player, pointed_thing)
        local playername = player:get_player_name()
        size(player, 1)
        sizes[playername] = 1
    end
});

if mcl_core then
    minetest.register_craft({
        output = 'shrinkme:reset',
        recipe = {
            {'mcl_core:cobble', 'mcl_core:iron_ingot', 'mcl_core:cobble'},
            {'mcl_core:iron_ingot', 'mcl_core:lapis', 'mcl_core:iron_ingot'},
            {'mcl_core:cobble', 'mcl_core:iron_ingot', 'mcl_core:cobble'},
        },
    })
    minetest.register_craft({
        output = 'shrinkme:shrinker',
        recipe = {
            {'mesecons:wire_00000000_off', 'mcl_core:iron_ingot', 'mesecons:wire_00000000_off'},
            {'mcl_core:iron_ingot', 'mcl_core:lapis', 'mcl_core:iron_ingot'},
            {'mesecons:wire_00000000_off', 'mcl_core:iron_ingot', 'mesecons:wire_00000000_off'},
        },
    })
    minetest.register_craft({
        output = 'shrinkme:grower',
        recipe = {
            {'mcl_core:lapis', 'mcl_core:iron_ingot', 'mcl_core:lapis'},
            {'mcl_core:iron_ingot', 'mcl_core:lapis', 'mcl_core:iron_ingot'},
            {'mcl_core:lapis', 'mcl_core:iron_ingot', 'mcl_core:lapis'},
        },
    })
end

