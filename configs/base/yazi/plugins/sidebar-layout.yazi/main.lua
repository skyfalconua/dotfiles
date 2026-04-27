--- Auto sidebar layout for yazi
--- Overrides Tab:layout() to hide the parent pane when the terminal is narrow.
---
--- based on https://github.com/josephschmitt/auto-layout.yazi
---

local function setup()
	local R = rt.mgr.ratio
	local orig_layout = Tab.layout

	Tab.layout = function(self)
		local w = self._area.w

		if w > 100 then
			-- Wide pane: use original 3-column layout
			self._chunks = ui.Layout()
				:direction(ui.Layout.HORIZONTAL)
				:constraints({
					ui.Constraint.Ratio(R.parent,  R.parent + R.current + R.preview),
					ui.Constraint.Ratio(R.current, R.parent + R.current + R.preview),
					ui.Constraint.Ratio(R.preview, R.parent + R.current + R.preview),
				})
				:split(self._area)
			return
		end

		-- Narrow pane (sidebar): hide parent, current = 40%, preview = 60%
		self._chunks = ui.Layout()
			:direction(ui.Layout.HORIZONTAL)
			:constraints({
				ui.Constraint.Ratio(0, 5),
				ui.Constraint.Ratio(2, 5),
				ui.Constraint.Ratio(3, 5),
			})
			:split(self._area)
	end
end

-- Run setup immediately when the plugin is loaded
setup()

return {}
