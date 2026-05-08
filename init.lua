-- juha_cords | CraftPlay777
-- Un solo comando /cords para ver coordenadas propias o de otro jugador.

local S = minetest.get_translator("juha_cords")

-- Manda las coordenadas al chat, público o privado según se pida
local function send_cords(sender, target_name, public)
	local player = minetest.get_player_by_name(target_name)
	if not player then
		return false, S("El jugador '@1' no está conectado", target_name)
	end

	local pos = player:get_pos()
	local msg = S("[Cords] @1: @2, @3, @4",
		target_name,
		math.floor(pos.x),
		math.floor(pos.y),
		math.floor(pos.z))

	if public then
		minetest.chat_send_all(minetest.colorize("#ffdd55", msg))
	else
		minetest.chat_send_player(sender, minetest.colorize("#55aaff", msg))
	end

	return true
end

minetest.register_chatcommand("cords", {
	description = S("Ver coordenadas. Uso: /cords [pub|priv] | /cords <jugador> [pub|priv]"),
	params = S("[pub|priv | <jugador> [pub|priv]]"),
	func = function(name, param)

		local args = {}
		for w in param:gmatch("%S+") do
			args[#args + 1] = w
		end

		if #args == 0 then
			return send_cords(name, name, false)
		end

		if args[1] == "pub" or args[1] == "priv" then
			return send_cords(name, name, args[1] == "pub")
		end

		local privs = minetest.get_player_privs(name)
		if not privs.teleport then
			return false, S("Necesitas el privilegio 'teleport' para ver coordenadas de otros")
		end

		local target = args[1]
		local public = false

		if args[2] then
			if args[2] == "pub" or args[2] == "priv" then
				public = args[2] == "pub"
			else
				return false, S("Uso: /cords <jugador> [pub|priv]")
			end
		end

		return send_cords(name, target, public)
	end
})

minetest.log("action", "[juha_cords] Cargado correctamente")