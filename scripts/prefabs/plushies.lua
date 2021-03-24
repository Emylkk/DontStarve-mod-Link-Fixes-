
local endresult = nil -- the item that is given in the final trade
local nameprefix = "trade" -- the prefix of the prefabs
local numtrades = 14 -- number of tradable items
local getname = function(suffix) return string.format("%s%02d", nameprefix, suffix) end -- example: prefix of test and suffix of 5 gives test05

local function MakePlushie( num, tradefor, tradeto, final )

	local plushiename = getname(num) -- name of prefab
	local bankname = "plushies" -- used in SetBank
	local buildname = bankname -- used in SetBuild
	local animname = buildname -- .zip file
	local animation = plushiename -- animation that is played
	local atlasname = "plushies" -- inventory image .xml
	-- if tradefor is a number instead of a string, get the name of the prefab at that number
	if type(tradefor) == "number" then 
		tradefor = getname(tradefor)
	end
	local ignoreaftertrade = nil
	if not final then
		ignoreaftertrade = {
			{ 
				name="plushies", 
				test=function(item) return item:HasTag("plushie") end, 
				time=TUNING.TOTAL_DAY_TIME*10 
			}
		}
	end

	local Assets =
	{
		Asset("ANIM", "anim/"..animname..".zip"),
		Asset("ATLAS", "images/inventoryimages/"..atlasname..".xml")
	}

	local function fn(Sim)
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()

		MakeInventoryPhysics(inst)
		
		inst.AnimState:SetBank( bankname )
		inst.AnimState:SetBuild( animname )
		inst.AnimState:PlayAnimation( plushiename )

		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/"..atlasname..".xml"

		inst:AddComponent("inspectable")
		
		inst:AddComponent("tradable")
		inst.components.tradable.tradefor = tradefor
		inst.components.tradable.tradeto = tradeto
		inst.components.tradable.ignoreaftertrade = ignoreaftertrade
		inst.components.tradable.goldvalue = 99
		
		inst:AddTag("irreplaceable")
		inst:AddTag("plushie")

		inst:ListenForEvent("ondropped", function(inst)
			inst:RemoveComponent("edible")
		end)

		inst:ListenForEvent("onpickup", function(inst)
			if not inst.components.edible then
				inst:AddComponent("edible")
				inst.components.edible.healthvalue = (math.huge)
				inst.components.edible.hungervalue = (math.huge)

				inst.components.edible.foodtype = "PLUSHIE"
			end
		end)

		return inst
	end

	-- Add some strings for this item
	STRINGS.NAMES.TRADE01 = "Yoshi Plushie"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRADE01 = "A huggable, soft, adorable little Yoshi plushie. Popular with the locals."
STRINGS.NAMES.TRADE02 = "Luigi Plushie"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRADE02 = "A huggable, soft, adorable little Luigi plushie. Popular with the locals."
STRINGS.NAMES.TRADE03 = "Mario Plushie"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRADE03 = "A huggable, soft, adorable little Mario plushie. Popular with the locals."
STRINGS.NAMES.TRADE04 = "Princess Peach Plushie"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRADE04 = "A huggable, soft, adorable little Princess Peach plushie. Popular with the locals."
STRINGS.NAMES.TRADE05 = "Bowser Plushie"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRADE05 = "A huggable, soft, adorable little Bowser plushie. Popular with the locals."
STRINGS.NAMES.TRADE06 = "Donkey Kong Plushie"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRADE06 = "A huggable, soft, adorable little Donkey Kong plushie. Popular with the locals."
STRINGS.NAMES.TRADE07 = "Kirby Plushie"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRADE07 = "A huggable, soft, adorable little Kirby plushie. Popular with the locals."
STRINGS.NAMES.TRADE08 = "Pikachu Plushie"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRADE08 = "A huggable, soft, adorable little Pikachu plushie. Popular with the locals."
STRINGS.NAMES.TRADE09 = "Pit Plushie"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRADE09 = "A huggable, soft, adorable little Pit plushie. Popular with the locals."
STRINGS.NAMES.TRADE10 = "Samus Plushie"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRADE10 = "A huggable, soft, adorable little Samus plushie. Popular with the locals."
STRINGS.NAMES.TRADE11 = "Sheik Plushie"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRADE11 = "A huggable, soft, adorable little Sheik plushie. Popular with the locals."
STRINGS.NAMES.TRADE12 = "Princess Zelda Plushie"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRADE12 = "A huggable, soft, adorable little Princess Zelda plushie. Popular with the locals."
STRINGS.NAMES.TRADE13 = "Ganondorf Plushie"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRADE13 = "A huggable, soft, adorable little Ganondorf plushie. Popular with the locals."
STRINGS.NAMES.TRADE14 = "Link Plushie"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRADE14 = "A huggable, soft, adorable little Link plushie. Fit for a king, if I do say so myself."
	--STRINGS.NAMES[string.upper(plushiename)] = plushiename
	--STRINGS.CHARACTERS.GENERIC.DESCRIBE[string.upper(plushiename)] = "Pigs would like to have this."

	return Prefab( "common/inventory/"..plushiename, fn, Assets )  
end  

local prefabs = {}
for i=1,numtrades-1 do
	table.insert(prefabs, MakePlushie( i, i+1, { "pigman" } ))
end
-- final one
table.insert(prefabs, MakePlushie( numtrades, endresult, { "pigking" }, true ))

return unpack(prefabs)