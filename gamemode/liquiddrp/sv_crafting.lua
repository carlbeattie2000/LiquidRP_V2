﻿local LDRP = {};
local craftingTextClr = Color(86, 168, 83);
LDRP.NiceNames = LDRP_SH.NicerWepNames;
function LDRP.CraftItem(ply, cmd, args)
  if ply:Team() ~= TEAM_CRAFTER then
    ply:LiquidChat("CRAFTING", craftingTextClr, "You must be a crafter to craft items.");
    return;
  end

  local Table = LDRP_SH.CraftItems[args[1]];
  if not Table or ply.Crafting then return; end
  if Table.vip and not ply:IsVIP() then
    ply:LiquidChat("CRAFTING", craftingTextClr, "You must be a VIP to craft this item.");
    return;
  elseif Table.lvl > ply.Character.Skills["Crafting"].lvl then
    ply:LiquidChat("CRAFTING", craftingTextClr, "You need a higher crafting level to craft this item.");
    return;
  end

  local am = 0;
  for k, v in pairs(Table.recipe) do
    am = am + 1;
    if not ply:HasItem(k, v) then
      ply:LiquidChat("CRAFTING", craftingTextClr, "You don't have the required resources in your inventory.");
      return;
    end
  end

  ply:Freeze(true);
  ply.Crafting = true;
  umsg.Start("SendMeter", ply);
  umsg.String("Crafting...");
  umsg.Float(Table.crafttime);
  umsg.End();
  timer.Simple(Table.crafttime, function()
    if not ply:IsValid() then return; end
    ply.Crafting = false;
    ply:Freeze(false);
    for k, v in pairs(Table.recipe) do
      ply:AddItem(k, -v);
    end

    local Str;
    local num = 0;
    for c, b in pairs(Table.results) do
      ply:AddItem(c, b);
      num = num + 1;
      if Str then
        Str = Str .. ", " .. b .. " " .. (LDRP.NiceNames[c] or c);
      else
        Str = b .. " " .. (LDRP.NiceNames[c] or c);
      end
    end

    ply:LiquidChat("CRAFTING", craftingTextClr, "Crafted " .. args[1] .. " (received " .. Str .. " in inventory.)");
    ply:GiveEXP("Crafting", Table.exp, true);
  end);
end

concommand.Add("__crft", LDRP.CraftItem);
