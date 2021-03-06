local area = param.get("area", "table")
local member = param.get("member", "table")

local show_content = param.get("show_content", atom.boolean)
local show_links = param.get("show_links", atom.boolean)

if app.session.member_id then
  area:load_delegation_info_once_for_member_id(app.session.member_id)
end

if not param.get("hide_unit", atom.boolean) then
  execute.view{ module = "unit", view = "_head", params = { unit = area.unit, member = member } }
end

local style = ""
if area.name == 'Sandkasten/Spielwiese' then
  style = "background: linear-gradient(rgb(227, 227, 227), rgb(198, 198, 198)) repeat scroll 0% 0% rgb(204, 204, 204)"
end

ui.container{ attr = { class = "area_head", style = style }, content = function()

  execute.view{ module = "delegation", view = "_info", params = { area = area, member = member } }

  ui.container{ attr = { class = "title" }, content = function()
    -- area name
    ui.link{
      module = "area", view = "show", id = area.id,
      attr = { class = "area_name" }, content = area.name 
    }
  end }
  
  if show_content then
    
    ui.container{ attr = { class = "content" }, content = function()

      -- actions (members with appropriate voting right only)
      if member then

        -- membership
        local membership = Membership:by_pk(area.id, member.id)

        if membership then
          
          if app.session.member_id == member.id then
            ui.tag{ content = _"You are participating in this area" }
            slot.put(" ")
            ui.tag{ content = function()
              slot.put("(")
              ui.link{
                image   = ui.image{ attr = { class = "spaceicon" }, static = "icons/16/folder_delete.png" },
                text    = _"Withdraw",
                module  = "membership",
                action  = "update",
                params  = { area_id = area.id, delete = true },
                routing = {
                  default = {
                    mode = "redirect",
                    module = request.get_module(),
                    view = request.get_view(),
                    id = param.get_id_cgi(),
                    params = param.get_all_cgi()
                  }
                }
              }
              slot.put(")")
            end }
          else
            ui.tag{ content = _"Member is participating in this area" }
          end

        elseif app.session.member_id == member.id and member:has_voting_right_for_unit_id(area.unit_id) then
          ui.link{
            image   = ui.image{ attr = { class = "spaceicon" }, static = "icons/16/folder_add.png" },
            text   = _"Participate in this area",
            module = "membership",
            action = "update",
            params = { area_id = area.id },
            routing = {
              default = {
                mode = "redirect",
                module = request.get_module(),
                view = request.get_view(),
                id = param.get_id_cgi(),
                params = param.get_all_cgi()
              }
            }
          }
        end
        
        if app.session.member_id == member.id and app.session.member:has_voting_right_for_unit_id(area.unit_id) then

          slot.put(" &middot; ")
          if area.delegation_info.own_delegation_scope ~= "area" then
            ui.link{ image = ui.image{ attr = { class = "spaceicon" }, static = "icons/16/folder_go.png" }, text = _"Delegate area", module = "delegation", view = "show", params = { area_id = area.id } }
          else
            ui.link{ image = ui.image{ attr = { class = "spaceicon" }, static = "icons/16/folder_go.png" }, text = _"Change area delegation", module = "delegation", view = "show", params = { area_id = area.id } }
          end
          slot.put(" &middot; ")

          ui.link{
            content = function()
              ui.image{ attr = { class = "spaceicon" }, static = "icons/16/page_white_add.png" }
              slot.put(_"Create new issue")
            end,
            module = "initiative",
            view = "new",
            params = { area_id = area.id }
          }
        end

      end

    end }

  else
    slot.put("<br />")
  end

end }
