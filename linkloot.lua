function LinkLootPostInit( inst )
  if GLOBAL.GetPlayer().prefab == "link" then
    inst.components.lootdropper:AddChanceLoot("rupee", .6)
    inst.components.lootdropper:AddChanceLoot("bombs", .9)
    inst.components.lootdropper:AddChanceLoot("arrows", .2)
--    inst.components.lootdropper:AddChanceLoot("heart", .3)
--    inst.components.lootdropper:AddChanceLoot("magjar", .3)
  end
end

function BossLootPostInit( inst )
  if GLOBAL.GetPlayer().prefab == "link" then
    inst.components.lootdropper:AddChanceLoot("rupee", 1.0)
--    inst.components.lootdropper:AddChanceLoot("heart", 1.0)
--    inst.components.lootdropper:AddChanceLoot("magjar", 1.0)
  end
end

                AddPrefabPostInit("bat", LinkLootPostInit)
                AddPrefabPostInit("birds", LinkLootPostInit)
                AddPrefabPostInit("beefalo", LinkLootPostInit)
                AddPrefabPostInit("bishop", LinkLootPostInit)
                AddPrefabPostInit("bishop_nightmare", LinkLootPostInit)
                AddPrefabPostInit("bunnyman", LinkLootPostInit)
                --Cave Spiders:
                AddPrefabPostInit("spider_dropper", LinkLootPostInit)
                AddPrefabPostInit("spider_hider", LinkLootPostInit)
                AddPrefabPostInit("spider_spitter", LinkLootPostInit)
                --
                AddPrefabPostInit("deerclops", BossLootPostInit)
                AddPrefabPostInit("eyeplant", LinkLootPostInit)
                AddPrefabPostInit("frog", LinkLootPostInit)
                --AddPrefabPostInit("ghost", LinkLootPostInit)
                AddPrefabPostInit("hound", LinkLootPostInit)
                AddPrefabPostInit("firehound", LinkLootPostInit)
                AddPrefabPostInit("icehound", LinkLootPostInit)
                AddPrefabPostInit("knight", LinkLootPostInit)
                AddPrefabPostInit("knight_nightmare", LinkLootPostInit)
                AddPrefabPostInit("koalefant_summer", LinkLootPostInit)
                AddPrefabPostInit("koalefant_winter", LinkLootPostInit)
                AddPrefabPostInit("krampus", LinkLootPostInit)
                AddPrefabPostInit("leif", BossLootPostInit)
                AddPrefabPostInit("lureplant", LinkLootPostInit)
                AddPrefabPostInit("merm", LinkLootPostInit)
                AddPrefabPostInit("minotaur", BossLootPostInit)
                AddPrefabPostInit("monkey", LinkLootPostInit)
                -- Nightmare creatures:
                AddPrefabPostInit("crawlingnightmare", LinkLootPostInit)
                AddPrefabPostInit("nightmarebeak", LinkLootPostInit)
                --
                AddPrefabPostInit("penguin", LinkLootPostInit)
                AddPrefabPostInit("perd", LinkLootPostInit)
                AddPrefabPostInit("pigman", LinkLootPostInit)
                AddPrefabPostInit("pigguard", LinkLootPostInit)
                AddPrefabPostInit("werepig", LinkLootPostInit)
                AddPrefabPostInit("rook", LinkLootPostInit)
                AddPrefabPostInit("rook_nightmare", LinkLootPostInit)
                -- Shadow creatures:
                AddPrefabPostInit("crawlinghorror", LinkLootPostInit)
                AddPrefabPostInit("terrorbeak", LinkLootPostInit)
                --
                --AddPrefabPostInit("shadowtentacle", LinkLootPostInit)
                AddPrefabPostInit("slurper", LinkLootPostInit)
                AddPrefabPostInit("slurtle", LinkLootPostInit)
                AddPrefabPostInit("snurtle", LinkLootPostInit)
                AddPrefabPostInit("spider", LinkLootPostInit)
                AddPrefabPostInit("spider_warrior", LinkLootPostInit)
                AddPrefabPostInit("spiderqueen", BossLootPostInit)
                AddPrefabPostInit("tallbird", LinkLootPostInit)
                AddPrefabPostInit("tentacle_pillar_arm", LinkLootPostInit)
                --AddPrefabPostInit("tentacle_pillar", LinkLootPostInit)
                AddPrefabPostInit("tentacle", LinkLootPostInit)
                AddPrefabPostInit("walrus", LinkLootPostInit)
                AddPrefabPostInit("little_walrus", LinkLootPostInit)