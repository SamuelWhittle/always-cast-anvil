local converted = false

for _,id in pairs(EntityGetInRadiusWithTag(pos_x, pos_y, 70, "wand")) do
    print("wand on anvil")
    EntityRemoveTag(id, "forgeable")
    print("tried to remove forgeable")
    -- make sure item is not carried in inventory or wand
    if EntityGetRootEntity(id) == id then
        print("entity on ground")
        local comp = EntityGetFirstComponentIncludingDisabled( id, "AbilityComponent" )
        local x,y = EntityGetTransform(id) -- Get location x y

        -- If Comp Exists
        if ( comp ~= nil ) then
            print("comp exists")
            -- if there is an always cast
            local deck_capacity = ComponentObjectGetValue( comp, "gun_config", "deck_capacity" )
            local deck_capacity2 = EntityGetWandCapacity( id )
            local always_casts = deck_capacity - deck_capacity2
            if ( always_casts > 0 ) then
                SetRandomSeed(x, y) -- do random stuff

                local behavior = ModSettingGet("always-cast-anvil.reforge_behavior")

                print("checking behavior")
                if behavior == "random" then
                    if ( Randomf(0, 1) > 0.5 ) then
                        behavior = "wand"
                    else
                        behavior = "spell"
                    end
                end

                if (EntityGetAllChildren(id) ~= nil) then -- If the Entity has at least one child
                    for _,child in pairs(EntityGetAllChildren(id)) do -- for every child
                        if (EntityHasTag(child, "card_action") ~= nil) then -- if the child has the card_action tag
                            print("child has card_action, checking permanent")
                            -- if the child's boolean "permanently_attached" is true
                            if ( ComponentGetValue2(EntityGetFirstComponentIncludingDisabled(child, "ItemComponent"), "permanently_attached") ) then
                                print("card_action was permanent")
                                EntityLoad("data/entities/projectiles/explosion.xml", x, y - 10)

                                if ( behavior == "spell" ) then
                                    -- Get the action_id that is permanently attached
                                    local action_id = ComponentGetValue2(EntityGetFirstComponentIncludingDisabled(child, "ItemActionComponent"), "action_id")

                                    -- create a spell using the action id as the spell id
                                    local spell = CreateItemActionEntity( action_id, x, y - 10)
                                    
                                    -- Get the velocity component
                                    local velocitycomp = EntityGetFirstComponent( spell, "VelocityComponent" )
                                
                                    -- if the velocity component exits, set the velocity values
                                    if velocitycomp ~= nil then
                                        ComponentSetValue2( velocitycomp, "mVelocity", Random(-50, 50), -50)
                                    end

                                    EntityKill(id)
                                elseif ( behavior == "wand" ) then
                                    EntityRemoveFromParent(child)
                                end

                                converted = true
                            end
                        end
                    end
                end
            end
        end
    end
end