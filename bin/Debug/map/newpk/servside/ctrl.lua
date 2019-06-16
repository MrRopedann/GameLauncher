function config(map)
    MapCanSavePos(map, 0) 
    MapCanPK(map, 1)
    MapCanTeam( map, 0 )
    MapType( map , 3 )
    MapCopyNum(map, 1) 
    SingleMapCopyPlyNum(map, 300)   
end

function get_map_entry_pos_bountypk()
	local POS_X=1338
	local POS_Y=583
	return POS_X , POS_Y
end

function init_entry(map)

    SetMapEntryMapName(map, "darkblue")
    SetMapEntryTime(map, "2006/10/18/1/0", "0/1/0", "0/1/0", "0/1/0") 
end

function after_enter_bountypk( role , map_copy )
end

function before_leave_bountypk( role )
end

function map_copy_run_special_bountypk( map_copy ) 
	local HowManyNoDead = GetMapActivePlayer(map_copy)
	Notice("На данный момент выживших в Баунти ПК: "..HowManyNoDead..".")
	Every_5_minute_BouPK = Every_5_minute_BouPK+1
	if Every_5_minute_BouPK == 1 then 
		local Monster1 = CreateChaEx(1190, 44239, 344876, 145, 60,map_copy)
		local Monster2 = CreateChaEx(1190, 44212, 342139, 145, 60,map_copy)
		local Monster3 = CreateChaEx(1190, 45012, 343439, 145, 60,map_copy)
		SetChaLifeTime(Monster1,299050)
		SetChaLifeTime(Monster2,299050)
		SetChaLifeTime(Monster3,299050)

	end
	if Every_5_minute_BouPK == 2 then 
		local Monster4 = CreateChaEx(185, 44239, 344876, 145, 60,map_copy)
		SetChaLifeTime(Monster4, 299050)
	end
	if Every_5_minute_BouPK == 3 then 
		local Monster5 = CreateChaEx(1191, 44239, 344876, 145, 60,map_copy)
		local Monster6 = CreateChaEx(1191, 44212, 342139, 145, 60,map_copy)
		local Monster7 = CreateChaEx(1191, 45012, 343439, 145, 60,map_copy)
		SetChaLifeTime(Monster5, 299050)
		SetChaLifeTime(Monster6, 299050)
		SetChaLifeTime(Monster7, 299050)
	end
	if Every_5_minute_BouPK == 4 then 
		local Monster8 = CreateChaEx(185, 44239, 344876, 145, 60,map_copy)
		SetChaLifeTime(Monster8, 299050)
	end
	if Every_5_minute_BouPK == 5 then 
		local Monster9 = CreateChaEx(1192, 44239, 344876, 145, 60,map_copy)
		local Monster10 = CreateChaEx(1192, 44212, 342139, 145, 60,map_copy)
		local Monster11 = CreateChaEx(1192, 45012, 343439, 145, 60,map_copy)
		SetChaLifeTime(Monster9, 299050)
		SetChaLifeTime(Monster10, 299050)
		SetChaLifeTime(Monster11, 299050)
	end
	if Every_5_minute_BouPK == 6 then 
		local Monster12 = CreateChaEx(185, 44239, 344876, 145, 60,map_copy)
		SetChaLifeTime(Monster12, 299050)
	end

	if Every_5_minute_BouPK == 7 then 
		local Monster13 = CreateChaEx(185, 44239, 344876, 145, 60,map_copy)
		SetChaLifeTime(Monster13, 299050)
	end

	if Every_5_minute_BouPK == 8 then 
		local Monster14 = CreateChaEx(1193, 44152, 343858, 145, 60,map_copy)
		SetChaLifeTime(Monster14, 897150)
	end
end

function map_run_bountypk( map )
end

function map_copy_before_close_bountypk( map_copy )
	How_Many_Active = GetMapActivePlayer(map_copy)
	if How_Many_Active > 0 then
		DealAllActivePlayerInMap(map_copy,"GiveSpecItem2")
	end
	How_Many_Active = 0
	Money_all = 2500000
	Every_5_minute_BouPK = 0
end

function map_copy_close_bountypk( map_copy )
	ClearAllSubMapCha(map_copy)
end

function can_open_entry_bountypk( map ) 

end 
 
function GiveSpecItem2( role )
	if How_Many_Active == 0 then
		return
	end
	
	local Money_bountypk = Money_all/How_Many_Active

	if How_Many_Active > 5 then
		AddMoney ( role , 0 , Money_bountypk )
		return
	end

	if How_Many_Active <  6 and How_Many_Active > 1 then
		local Item_CanGet = GetChaFreeBagGridNum ( role )
		if Item_CanGet <= 0 then
			GiveItemX ( role , 0 , 1031  , 1 , 4 )
		else
			GiveItem ( role , 0 , 1031  , 1 , 4 )
		end
			 
		AddMoney ( role , 0 , Money_bountypk )
		return
	end
	
	if How_Many_Active == 1 then
		local Item_CanGet = GetChaFreeBagGridNum ( role )
		if Item_CanGet <= 0 then
			GiveItemX ( role , 0 , 1032  , 1 , 4 )
		else
			GiveItem ( role , 0 , 1032  , 1 , 4 )
		end
		AddMoney ( role , 0 , Money_bountypk )
		local cha_name = GetChaDefaultName ( role )
		local message = "Поздравляем тебя, "..cha_name.."! В качестве приза ты получаешь ".. Money_bountypk .." золота и 1 Эмблему короля, каторую можешь обменять на Хаос Сундук."
		SystemNotice(role,message)
		return
	end
end 

function map_copy_run_bountypk( map_copy )
	local HowManyNoDead = GetMapActivePlayer(map_copy)
	if HowManyNoDead > 0 then
		DealAllActivePlayerInMap(map_copy,"kick")
	end
end
function kick(role)
	if IsInTeam(role) == 1 then
		MoveCity(role, "Argent City") 
		SystemNotice(role, "\194 \209\229\240\229\225\240\255\237\238\236 \245\224\238\241\229 \237\229\235\252\231\255 \225\251\242\252 \226 \238\242\240\255\228\229 \241 \228\240\243\227\232\236\232 \232\227\240\238\234\224\236\232! \194\251 \234\232\234\237\243\242\251 \241 \234\224\240\242\251!")
	end
end