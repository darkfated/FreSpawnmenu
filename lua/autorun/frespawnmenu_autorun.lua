local inc = SERVER and AddCSLuaFile or include

if ( SERVER ) then
	resource.AddFile( 'materials/gwenskin/frespawnmenu.png' )
end

inc( 'frespawnmenu/dermaskin.lua' )
inc( 'frespawnmenu/core.lua' )
