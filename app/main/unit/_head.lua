local unit = param.get("unit", "table")
local member = param.get("member", "table")

local show_content = param.get("show_content", atom.boolean)
local show_links = param.get("show_links", atom.boolean)

if app.session.member_id then
  unit:load_delegation_info_once_for_member_id(app.session.member_id)
end

local style = ""
if unit.name == 'Sandkasten/Spielwiese' then
  style = "background: linear-gradient(rgb(147, 147, 147), rgb(85, 85, 85)) repeat scroll 0% 0% rgb(102, 102, 102)";
end

ui.container{ attr = { class = "unit_head", style = style }, content = function()

  execute.view{ module = "delegation", view = "_info", params = { unit = unit, member = member } }

  ui.container{ attr = { class = "title" }, content = function()
    if not config.single_unit_id then
      ui.link{ 
        image = ui.image{ attr = { class = "spaceicon", style = "width: 16px; height: 16px;" }, static = "icons/units/" .. unit.name .. ".ico" },
        module = "unit", view = "show", id = unit.id,
        attr = { class = "unit_name" }, content = unit.name
      }
    else
      ui.link{ 
        module = "unit", view = "show", id = unit.id,
        attr = { class = "unit_name" }, content = _"Liquid" .. " &middot; " .. config.instance_name
      }
    end
  end }

  if show_content then
    ui.container{ attr = { class = "content" }, content = function()

      if member and member:has_voting_right_for_unit_id(unit.id) then
        if app.session.member_id == member.id then
          ui.tag{ content = _"You have voting privileges for this unit" }
          slot.put(" &middot; ")
          if unit.delegation_info.first_trustee_id == nil then
            ui.link{ image = ui.image{ attr = { class = "spaceicon" }, static = "icons/16/house_go.png" }, text = _"Delegate unit", module = "delegation", view = "show", params = { unit_id = unit.id } }
          else
            ui.link{ image = ui.image{ attr = { class = "spaceicon" }, static = "icons/16/house_go.png" }, text = _"Change unit delegation", module = "delegation", view = "show", params = { unit_id = unit.id } }
          end
        else
          ui.tag{ content = _"Member has voting privileges for this unit" }
        end
      end
    end }
  else
    slot.put("<br />")
  end
    
end }
