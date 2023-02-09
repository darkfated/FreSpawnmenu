local inc = SERVER and AddCSLuaFile or include

if ( SERVER ) then
	resource.AddWorkshop('2924839375') -- Font
	resource.AddWorkshop( '2613708971' )
end

inc( 'frespawnmenu/dermaskin.lua' )
inc( 'frespawnmenu/dermaskin_dark.lua' )
inc( 'frespawnmenu/core.lua' )
