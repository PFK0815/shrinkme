local playerphysicsMOD = minetest.get_modpath("playerphysics") ~= nil

entity_modifier.resize_player = function(player, size)
	local player_name = player:get_player_name()
	size = size or 1
	--a too high number makes the game lag
	if size < 0 or size > 80 then
		minetest.chat_send_player(player_name, "Invalid size: " .. size)
		return
	end

	if size == 1 then
		player:set_eye_offset(
			{x=0, y=0, z=0},
			{x=0, y=0, z=0}
		)
	elseif size < 1 then
		player:set_eye_offset(
			{x=0, y=size, z=0},
			{x=0, y=-(size * 5), z=math.floor(5.5 - size * 5)}
		)
		if size == 1/2 then
			player:set_eye_offset(
				{x=0, y=-8, z=0},
				{x=0, y=-(size * 5), z=math.floor(5.5 - size * 5)}
			)
		elseif size == 1/4 then
			player:set_eye_offset(
				{x=0, y=-12, z=0},
				{x=0, y=-(size * 5), z=math.floor(5.5 - size * 5)}
			)
		elseif size == 1/8 then
			player:set_eye_offset(
				{x=0, y=-14, z=0},
				{x=0, y=-(size * 5), z=math.floor(5.5 - size * 5)}
			)
		elseif size == 1/16 then
			player:set_eye_offset(
				{x=0, y=-15, z=0},
				{x=0, y=-(size * 5), z=math.floor(5.5 - size * 5)}
			)
		end

	else
		player:set_eye_offset(
			{x=0, y=size * 10, z=-size},
			{x=0, y=size * 5, z=-size}
		)
	end

	local new_properties = {}

	new_properties.visual_size = {x=size, y=size}

	if playerphysicsMOD then
		-- MINECLONE
		playerphysics.add_physics_factor(player, "speed", "shrinkme:speed", size)
	end

	player:set_properties(new_properties)
end

minetest.register_privilege("resize", {
	description = "Can resize players"
})

minetest.register_chatcommand("resize", {
	params = "resize <name> [<size>]",
	description = "resize a player size (0.0 to 80)",
	privs = { resize = true },
	func = function(name, params)
		local args = params:split(" ")
		local player_name = args[1]
		if not player_name then
			minetest.chat_send_player(name, "Invalid usage: " .. params)
			return
		end

		local player = minetest.get_player_by_name(player_name)
		if player then
			entity_modifier.resize_player(player, tonumber(args[2]))
		else
			minetest.chat_send_player(name, "Invalid player name: " .. player_name)
		end
	end
})

minetest.register_chatcommand("resizeme", {
	params = "resizeme [<size>]",
	description = "resize your player size (0.0 to 80)",
	privs = { resize = true },
	func = function(player_name, size_string)
		entity_modifier.resize_player(
			minetest.get_player_by_name(player_name),
			tonumber(size_string)
		)
	end
})
