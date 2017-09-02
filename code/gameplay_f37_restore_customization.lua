-- Restore clothes+customization script
-- Author(s):       iFarbod <ifarbod@outlook.com>
--
-- Copyright (c) 2015-2017 CTNorth Team
--
-- Distributed under the MIT license (See accompanying file LICENSE or copy at
-- https://opensource.org/licenses/MIT)

-- Thread handle
F37_RESTORE_CUSTOMIZATION_THREAD = INVALID_THREAD_HANDLE

-- Button stuff
F37_RELOAD_PUSHED = false
F37_B_LBRACKET = "CBA_FIGHT_CLUB_BLOCK"

function f37_restore_customization_message(msg)
    mission_help_table(msg, LOCAL_PLAYER)
end

-- This function restores clothes just like after any mission
function f37_restore_customization_restore_clothes_for_players()
    -- Put both players' names in a table
    local player_list = player_names_get_all()
    
    -- Restore clothes!
    players_naked(false)
    
    -- Wait until both players get their clothes back
    for i, player in pairs(player_list) do
        while not player_customization_is_finalized(player) do
            thread_yield()
        end
    end
end

function f37_restore_customization_input_loop()
    if player_action_is_pressed("CBA_OFC_PICKUP_RELOAD") then -- R(eload)
        -- R + [
        if player_action_is_pressed(F37_B_LBRACKET) and not F37_RELOAD_PUSHED then
            f37_restore_customization_restore_clothes_for_players()
            f37_restore_customization_message("MOD_GP_SCRIPT_F37_RESTORE_CUSTOMIZATION_NOTICE")
            F37_RELOAD_PUSHED = true
        end
    end
    
    if not player_action_is_pressed("CBA_OFC_PICKUP_RELOAD") then
        F37_RELOAD_PUSHED = false
    end
end

function f37_restore_customization_thread()
    while true do
        f37_restore_customization_input_loop()
        delay(0.5)
    end
end

-- Gameplay functions that get called by the game's EXE on certain occasions
-- Initialization for host
function gameplay_f37_restore_customization_init()
    F37_RESTORE_CUSTOMIZATION_THREAD = thread_new("f37_restore_customization_thread")
end

-- Initialization for client
function gameplay_f37_restore_customization_init_client()

end

-- City load for host
function gameplay_f37_restore_customization_main()

end

-- City load for client
function gameplay_f37_restore_customization_main_client()

end