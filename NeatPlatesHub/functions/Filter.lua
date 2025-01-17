
local AddonName, HubData = ...;
local LocalVars = NeatPlatesHubDefaults

local GetUnitSubtitle = NeatPlatesUtility.GetUnitSubtitle
local GetUnitQuestInfo = NeatPlatesUtility.GetUnitQuestInfo
local IsPartyMember = NeatPlatesUtility.IsPartyMember

------------------------------------------------------------------------------
-- Unit Filter
------------------------------------------------------------------------------
local function UnitFilter(unit)
	if LocalVars.OpacityFilterLookup[unit.name] then return true
	elseif LocalVars.OpacityFilterNeutralUnits and unit.reaction == "NEUTRAL" then return true
	elseif LocalVars.OpacityFilterUntitledFriendlyNPC and unit.type == "NPC" and unit.reaction == "FRIENDLY" and not (GetUnitSubtitle(unit) or GetUnitQuestInfo(unit))  then return true
	elseif LocalVars.OpacityFilterFriendlyNPC and unit.type == "NPC" and unit.reaction == "FRIENDLY" then return true
	elseif LocalVars.OpacityFilterEnemyNPC and unit.type == "NPC" and unit.reaction == "HOSTILE" then return true
	elseif LocalVars.OpacityFilterPlayers and unit.type == "PLAYER" then return true
	elseif LocalVars.OpacityFilterPartyMembers and unit.type == "PLAYER" and IsPartyMember(unit.unitid) then return true
	elseif LocalVars.OpacityFilterNonPartyMembers and unit.type == "PLAYER" and not IsPartyMember(unit.unitid) then return true
	elseif LocalVars.OpacityFilterMini and unit.isMini then return true
	elseif LocalVars.OpacityFilterNonElite and (not unit.isElite) then return true
	elseif LocalVars.OpacityFilterInactive then

		if GetUnitQuestInfo(unit) then return false end

		if unit.reaction ~= "FRIENDLY" then
			if not (unit.isMarked or unit.isInCombat or unit.threatValue > 0 or unit.health < unit.healthmax) then
				return true
			end
		end
	end
end

------------------------------------------------------------------------------
-- Local Variable
------------------------------------------------------------------------------

local function OnVariableChange(vars) LocalVars = vars end
HubData.RegisterCallback(OnVariableChange)

------------------------------------------------------------------------------
-- Add References
------------------------------------------------------------------------------
NeatPlatesHubFunctions.UnitFilter = UnitFilter

