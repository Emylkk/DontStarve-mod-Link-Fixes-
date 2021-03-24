local require = GLOBAL.require
local SpawnPrefab = GLOBAL.SpawnPrefab
--
require "class"
--
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local STRINGS = GLOBAL.STRINGS
local ACTIONS = GLOBAL.ACTIONS
local Action = GLOBAL.Action
--
local InvSlot = require "widgets/invslot"
local TileBG = require "widgets/tilebg"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local EquipSlot = require "widgets/equipslot"
local ItemTile = require "widgets/itemtile"
--
require "TradeSequence/trader_ignoreitems"

STRINGS.NAMES.LINKSWORD = "Hero's Sword"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LINKSWORD = "A legendary sword wielded by many great heroes in the legends of Hyrule."
STRINGS.NAMES.OCARINA = "Hero's Ocarina"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.OCARINA = "A mystical Ocarina, passed down through the Royal Family of Hyrule."
STRINGS.NAMES.SHIELD = "Hero's Shield"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHIELD = "A sturdy shield, fit for a Hero."
STRINGS.NAMES.LINKERANG = "Hero's Boomerang"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LINKERANG = "An enchanted Boomerang, that always returns to its owner's hand."
STRINGS.NAMES.WOODSWORD = "Wooden Sword"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WOODSWORD = "A simple wooden sword."
STRINGS.RECIPE_DESC.WOODSWORD = "A simple wooden sword."
STRINGS.NAMES.WDSHIELD = "Wooden Shield"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WDSHIELD = "A simple wooden shield."
STRINGS.RECIPE_DESC.WDSHIELD = "A simple wooden shield."
STRINGS.NAMES.MEGTON = "Hero's Hammer"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MEGTON = "A legendary Hammer, forged by magic. Capable of bringing even the sturdiest structure, or toughest boulder to rubble."
STRINGS.NAMES.HEROLAN = "Hero's Lantern"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HEROLAN = "An ornate Lantern, capable of expelling small bursts of fire to ignite flammable objects."
STRINGS.NAMES.TUNIC_RED = "Hero's Red Tunic"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TUNIC_RED = "A fireproof Red Tunic."
STRINGS.NAMES.TUNIC_BLUE = "Hero's Blue Tunic"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TUNIC_BLUE = "An ice-proof Blue Tunic."
STRINGS.NAMES.TRULENS = "Hero's Lens of Truth"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRULENS = "A magical Lens that reveals secrets invisible to the naked eye."
STRINGS.NAMES.BUNNYHOOD = "Hero's Bunny Hood"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BUNNYHOOD = "An adorable hat with long, floppy ears, that fills the wearer with the spirit and agility of the wild."
STRINGS.NAMES.BOTTLE_E = "Empty Bottle"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOTTLE_E = "An empty bottle to store things in."
STRINGS.NAMES.BOTTLE_R = "Red Potion"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOTTLE_R = "A bottle of rejuvenating Red Potion."
STRINGS.RECIPE_DESC.BOTTLE_R = "A bottle of rejuvenating Red Potion."
STRINGS.NAMES.BOTTLE_G = "Green Potion"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOTTLE_G = "A bottle of refreshing Green Potion."
STRINGS.RECIPE_DESC.BOTTLE_G = "A bottle of refreshing Green Potion."
STRINGS.NAMES.BOTTLE_B = "Blue Potion"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOTTLE_B = "A bottle of refreshing and rejuvenating Blue Potion."
STRINGS.RECIPE_DESC.BOTTLE_B = "A bottle of refreshing and rejuvenating Blue Potion."
STRINGS.NAMES.DINROCK = "Din's Fire"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DINROCK = "A magical stone that radiates the Power of the goddess Din."
STRINGS.NAMES.FARORROCK = "Farore's Wind"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FARORROCK = "A magical stone that radiates the Courage of the goddess Farore."
STRINGS.NAMES.NAYRUROCK = "Nayru's Love"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.NAYRUROCK = "A magical stone that radiates the Wisdom of the goddess Nayru."
STRINGS.NAMES.BOMBS = "Bombs"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOMBS = "Don't stop to admire these! Run!"
STRINGS.RECIPE_DESC.BOMBS = "Powerful explosives. Ten of them."
STRINGS.NAMES.FAIRY = "Spryte"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FAIRY = "Your trusty fairy companion!" 
STRINGS.NAMES.ARROWS = "Arrows"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARROWS = "Quite useless without a bow."
STRINGS.RECIPE_DESC.ARROWS = "Simple projectile ammunition for the bow. Bundle of ten."
STRINGS.NAMES.RUPEE = "Rupees"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.RUPEE = "All this money, and nowhere to spend it..."
STRINGS.ACTIONS.MARK = "Create Warp Point"      
STRINGS.ACTIONS.RECALL = "Warp to Point"
STRINGS.ACTIONS.RESET = "Remove Warp Point"

PrefabFiles = {
	"link",
	"linksword",
	"ocarina",
	"shield",
	"linkerang",
	"woodsword",
	"megton",
	"herolan",
	"wdshield",
	"tunic_red",
	"tunic_blue",
	"trulens",
	"bunnyhood",
	"bottle_e",
	"bottle_r",
	"bottle_g",
	"bottle_b",
	"dinrock",
	"dinfire",
	"farorrock",
	"nayrurock",
	"bombs",
	"plushies",
	"arrows",
    "rupee",
    "acorn_door"
}

Assets = { 
    Asset( "IMAGE", "images/saveslot_portraits/link.tex" ),
    Asset( "IMAGE", "images/selectscreen_portraits/link.tex" ),
    Asset( "IMAGE", "images/selectscreen_portraits/link_silho.tex" ),
    Asset( "IMAGE", "bigportraits/link.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/link.xml" ),
    Asset( "ATLAS", "images/selectscreen_portraits/link.xml" ),
    Asset( "ATLAS", "images/selectscreen_portraits/link_silho.xml" ),
    Asset( "ATLAS", "bigportraits/link.xml" ),
---------------------------------------------------------------------------
    --Asset("ANIM", "anim/fairy.zip"),
    Asset("ATLAS", "images/inventoryimages/herotab.xml")
    
}


--[[
-- Here we prevent the percentage from showing up for the shield using some programming voodoo.
--]]
--GLOBAL.require "widgets/inventoryslot"
local oldSetPercent = ItemTile.SetPercent
function ItemTile:SetPercent(percent)
	if percent == percent then
		oldSetPercent(self, percent)
	end
end

--[[Code by Kiopho for Always On Status compatibility - disabled; apparently out-of-date; preserved just in case
local function AoSFix(inst) 
inst:AddComponent("switch") 
end 

for _, moddir in ipairs(GLOBAL.KnownModIndex:GetModsToLoad()) do 
if GLOBAL.KnownModIndex:GetModInfo(moddir).name == "Always On Status" then 
AddPrefabPostInit("link", AoSFix) 
end 
end
--]]
---------------------------------------------------

STRINGS.TABS.HERO = "Heroic"
GLOBAL.RECIPETABS['HERO'] = {str = "HERO", sort=-2, icon = "herotab.tex", icon_atlas = "images/inventoryimages/herotab.xml"}

--------
function LinkPostInit(link)
------

------
        local emptybottle = GLOBAL.Ingredient( "bottle_e", 1)
        emptybottle.atlas = "images/inventoryimages/bottle_e.xml"
        local swordrecipe = GLOBAL.Recipe( "woodsword", { Ingredient("twigs", 2)}, RECIPETABS.HERO, {SCIENCE = 0} )
        swordrecipe.atlas = "images/inventoryimages/woodsword.xml"
        local shieldrecipe = GLOBAL.Recipe( "wdshield", { Ingredient("log", 2)}, RECIPETABS.HERO, {SCIENCE = 0} )
        shieldrecipe.atlas = "images/inventoryimages/wdshield.xml"
        local redpotrecipe = GLOBAL.Recipe( "bottle_r", { emptybottle,Ingredient("red_cap", 1),Ingredient("spidergland", 5)}, RECIPETABS.HERO, {SCIENCE = 0} )
        redpotrecipe.atlas = "images/inventoryimages/bottle_r.xml"
        local greenpotrecipe = GLOBAL.Recipe( "bottle_g", { emptybottle,Ingredient("green_cap", 1),Ingredient("honey", 3)}, RECIPETABS.HERO, {SCIENCE = 0} )
        greenpotrecipe.atlas = "images/inventoryimages/bottle_g.xml"
        local bluepotrecipe = GLOBAL.Recipe( "bottle_b", { emptybottle,Ingredient("blue_cap", 1),Ingredient("spidergland", 5),Ingredient("honey", 3)}, RECIPETABS.HERO, {SCIENCE = 0} )
        bluepotrecipe.atlas = "images/inventoryimages/bottle_b.xml"
--        
        local bombrecipe = GLOBAL.Recipe( ("bombs"), { Ingredient("rope", 10),Ingredient("flint", 10),Ingredient("gunpowder", 5),Ingredient("goldnugget", 2)}, RECIPETABS.HERO, {SCIENCE = 0}, nil, nil, nil, 10 )
        bombrecipe.atlas = "images/inventoryimages/bombs.xml"
        
        local arrowrecipe = GLOBAL.Recipe( ("arrows"), { Ingredient("twigs", 5),Ingredient("flint", 2)}, RECIPETABS.HERO, {SCIENCE = 0}, nil, nil, nil, 10 )
        arrowrecipe.atlas = "images/inventoryimages/arrows.xml"
        
end

AddSimPostInit(function(inst)
        if inst.prefab == "link" then
                LinkPostInit(inst)
        end
end)

---------- 
local DROPSINGLE = Action({mount_enabled=false}, true, true)
DROPSINGLE.id = "DROPSINGLE"
DROPSINGLE.str = "Drop"
DROPSINGLE.fn = function(act)
    if act.doer.components.inventory then
        local dropped_item = act.doer.components.inventory:DropItem(act.invobject, false, false, act.pos)
        if dropped_item then
            dropped_item:PushEvent("onsingledropped")
        end
        return true
    end
end
 
AddAction(DROPSINGLE)
  
GLOBAL.ACTIONS.DROPSINGLE = DROPSINGLE
---------------------------------------
-- Pigmen trading sequence stuff
---------------------------------------

function PigManPostInit( inst )
	table.insert( inst.components.eater.foodprefs, "PLUSHIE" )

	MakePlushieTradable( inst )
	MakeAcceptPlushie( inst )
end

function PigKingPostInit( inst )
	-- Note: The pig king does not have an "eat" animation

	MakePlushieTradable( inst )
	MakeAcceptPlushie( inst )

	inst:ListenForEvent("trade", PigKingOnTrade)
end

function MakePlushieTradable( inst )
	local trader_test_base = inst.components.trader.test
	inst.components.trader.test = function(inst, item)
		local shouldaccept = trader_test_base(inst, item)

		if not shouldaccept then
			if item:HasTag("plushie") then
				shouldaccept = true
			end
		end

		return shouldaccept
	end
end

function MakeAcceptPlushie( inst )
	local trader_onaccept_base = inst.components.trader.onaccept
	inst.components.trader.onaccept = function(inst, giver, item)
		trader_onaccept_base(inst, giver, item)

		if item:HasTag("plushie") and giver.components.inventory and item.components.tradable.tradefor then
			local give = SpawnPrefab( item.components.tradable.tradefor )
			if give then
				giver.components.inventory:GiveItem( give )
			end
		end
	end
end

function PigKingOnTrade(inst, data)
	local giver, item = data.giver, data.item

	if item:HasTag("plushie") then
		PigKingCelebrate(inst)
	end
end

function PigKingCelebrate(inst)
        inst.AnimState:PlayAnimation("cointoss")
        inst.AnimState:PushAnimation("happy")
        inst.AnimState:PushAnimation("idle", true)
        inst:DoTaskInTime(20/30, function()
            inst.SoundEmitter:PlaySound("dontstarve/pig/PigKingThrowGold")
            
                local btl = GLOBAL.SpawnPrefab("bottle_e")
                local pt = GLOBAL.Vector3(inst.Transform:GetWorldPosition()) + GLOBAL.Vector3(0,4.5,0)
                
                btl.Transform:SetPosition(pt:Get())
                local down = GLOBAL.TheCamera:GetDownVec()
                local angle = math.atan2(down.z, down.x) + (math.random()*60-30)*GLOBAL.DEGREES
                --local angle = (-TUNING.CAM_ROT-90 + math.random()*60-30)/180*PI
                local sp = math.random()*4+2
btl.Physics:SetVel(sp*math.cos(angle), math.random()*2+8, sp*math.sin(angle))
            end)
--        end)
        inst:DoTaskInTime(1.5, function()
            inst.SoundEmitter:PlaySound("dontstarve/pig/PigKingHappy")
        end)
        inst.happy = true
        if inst.endhappytask then
            inst.endhappytask:Cancel()
        end
        inst.endhappytask = inst:DoTaskInTime(5, function()
            inst.happy = false
            inst.endhappytask = nil
    end)
end

AddPrefabPostInit("pigman", PigManPostInit)
AddPrefabPostInit("pigking", PigKingPostInit)

---------------------------------------
function StoneSimPostInit()

ACTIONS.RECHARGE = GLOBAL.Action({mount_enabled=false})
ACTIONS.RECHARGE.fn = function(act)
	if act.target and act.target.components.finiteuses and act.invobject and act.invobject.components.recharger then
		return act.invobject.components.recharger:StoneRecharge(act.target, act.doer)
	end
end

ACTIONS.RESET = GLOBAL.Action({mount_enabled=false})
ACTIONS.RESET.fn = function(act)
 local tar = act.target or act.invobject
  if tar and tar.components.telestone and tar.components.telestone:IsMarked() or tar.components.telestone:IsMarkedCave() then
            tar.components.telestone:Reset(tar)
        return true
    end
end

ACTIONS.MARK = GLOBAL.Action({mount_enabled=false})
ACTIONS.MARK.fn = function(act)
 local tar = act.target or act.invobject
  if tar and tar.components.telestone and not tar.components.telestone:IsMarked() or not tar.components.telestone:IsMarkedCave() then
        tar.components.telestone:Mark(tar)
        return true
    end
end

ACTIONS.RECALL = GLOBAL.Action({mount_enabled=false})
ACTIONS.RECALL.fn = function(act)
  local tar = act.target or act.invobject
   if tar and tar.components.telestone and tar.components.telestone:IsMarked() or tar.components.telestone:IsMarkedCave() then
             tar.components.telestone:Recall(act.doer)
         return true
     end
end
 
for k,v in pairs(ACTIONS) do
	if (k == "MARK" or k == "RECALL" or k == "RESET" or k == "RECHARGE") then
    		v.str = STRINGS.ACTIONS[k] or "ACTION"
   		 v.id = k
	 end
end

local function addActionHandler(SGname, action, state, condition)
	actionHandler = GLOBAL.ActionHandler(action, state, condition)
	for k,v in pairs(GLOBAL.SGManager.instances) do	
		if(k.sg.name == SGname) then
			k.sg.actionhandlers[action] = actionHandler
			break
		end
	end
end

local function addState(SGname, state)
	 for k,v in pairs(GLOBAL.SGManager.instances) do	
		if(k.sg.name == SGname) then
			k.sg.states[state.name] =  state
			break
		end
	 end
end

addActionHandler("wilson", GLOBAL.ACTIONS.RECHARGE, "dolongaction")

addActionHandler("wilson", GLOBAL.ACTIONS.RESET, "reset")

local reset = GLOBAL.State{
        name = "reset",
        tags = {"doing"},
        
        onenter = function(inst, timeout)
            
            inst.sg:SetTimeout(timeout or 1)
            inst.components.locomotor:Stop()
            inst.SoundEmitter:PlaySound("dontstarve/rain/thunder_close", "make")
            
            inst.AnimState:PlayAnimation("build_pre")
            inst.AnimState:PushAnimation("build_loop", true)
        end,
        
        ontimeout= function(inst)
            inst.AnimState:PlayAnimation("build_pst")
            inst.sg:GoToState("idle", false)
            inst:PerformBufferedAction()
        
        end,
        
        onexit= function(inst)
            inst.SoundEmitter:KillSound("make")
        end, 
    }

    addState("wilson", reset)	

addActionHandler("wilson", GLOBAL.ACTIONS.MARK, "mark")

local mark = GLOBAL.State{
        name = "mark",
        tags = {"doing"},
        
        onenter = function(inst, timeout)
            
            inst.sg:SetTimeout(timeout or 1)
            inst.components.locomotor:Stop()
            inst.SoundEmitter:PlaySound("dontstarve/common/lightningrod", "make")
            
            inst.AnimState:PlayAnimation("build_pre")
            inst.AnimState:PushAnimation("build_loop", true)
        end,
        
        ontimeout= function(inst)
            inst.AnimState:PlayAnimation("build_pst")
            inst.sg:GoToState("idle", false)
            inst:PerformBufferedAction()
        
        end,
        
        onexit= function(inst)
            inst.SoundEmitter:KillSound("make")
        end, 
    }

    addState("wilson", mark)	

addActionHandler("wilson", GLOBAL.ACTIONS.RECALL, "recall")

local recall = GLOBAL.State{
        name = "recall",
        tags = {"doing"},
        
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("teleport")

			inst:DoTaskInTime(4.7, function(inst) inst.SoundEmitter:PlaySound("dontstarve/common/teleportato/teleportato_pulled") end )
        end,
        
		timeline =
        {
			GLOBAL.TimeEvent(19*GLOBAL.FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/common/teleportato/teleportato_under") end),
		},

        events=
        {
            GLOBAL.EventHandler("animover", function(inst)
				inst:PerformBufferedAction()
				inst.sg:GoToState("idle") 
			end ),
        },
    }

	addState("wilson", recall)
	
end

AddSimPostInit(StoneSimPostInit)
--------------------------------------------------------------------
STRINGS.CHARACTER_TITLES.link = "The Hero"
STRINGS.CHARACTER_NAMES.link = "Link"
STRINGS.CHARACTER_DESCRIPTIONS.link = "*Braver.\n*Stronger.\n*More... heroic."
STRINGS.CHARACTER_QUOTES.link = "\"Well excuuuuuuuse me, princess!\""
--------------------------------------------------------------------
--STRINGS.CHARACTERS.LINK = {}
--STRINGS.CHARACTERS.LINK.DESCRIBE = {}
STRINGS.CHARACTERS.LINK=require "speech_link"

table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "link")

AddModCharacter("link")
modimport "ocarina_playing.lua"
modimport "linkloot.lua"
modimport "initmagic.lua"
modimport "no_talking_anim.lua"
--modimport "talking_fairy.lua"
modimport "sword_cut_grass.lua"
modimport "RoG_additions.lua"
modimport "get_item_with_linkerang.lua"