﻿if SERVER then
  local meta = FindMetaTable("Player");
  function meta:LiquidChat(nam, col, msg)
    if not self or not self:IsValid() then return; end
    umsg.Start("LiquidChat", self);
    umsg.String(nam);
    umsg.Vector(Vector(col.r, col.g, col.b));
    umsg.String(msg);
    umsg.End();
  end
else
  local function LiquidChatRec(um)
    local nam = um:ReadString();
    local vcol = um:ReadVector();
    local col = Color(vcol.x, vcol.y, vcol.z);
    local msg = um:ReadString();
    chat.AddText(unpack({col, "[" .. nam .. "] ", Color(255, 255, 255), msg}));
    chat.PlaySound();
  end

  usermessage.Hook("LiquidChat", LiquidChatRec);
end
