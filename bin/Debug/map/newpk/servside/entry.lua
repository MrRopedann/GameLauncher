function config_entry(entry) 
    SetMapEntryEntiID(entry, 193,1)
end 

function after_create_entry(entry) 
    local copy_mgr = GetMapEntryCopyObj(entry, 0)
    local EntryName = "Баунти ПК"
    SetMapEntryEventName( entry, EntryName )
    map_name, posx, posy, tmap_name = GetMapEntryPosInfo(entry)
    Notice("Объявление: в Великом Синем океане в точке ["..posx..","..posy.."] открылся портал, ведущий в Баунти ПК.")
end

function after_destroy_entry_bountypk(entry)
    map_name, posx, posy, tmap_name = GetMapEntryPosInfo(entry) 
    Notice("Объявление: Портал в [Баунти ПК] закрылся. Возрадуйтесь!") 
end

function after_player_login_bountypk(entry, player_name)
    map_name, posx, posy, tmap_name = GetMapEntryPosInfo(entry)
    ChaNotice(player_name, "Объявление: в Великом Синем океане в точке ["..posx..","..posy.."] открылся портал, ведущий в Баунти ПК.")
end

function check_can_enter_bountypk( role, copy_mgr )
	local FightingBook_Num = 0
	FightingBook_Num = CheckBagItem( role,3849 )
	local Team_In = IsInTeam(role)
	if Team_In == 1 then
		SystemNotice ( role , "Нельзя войти в Баунти ПК, находясь в отряде." )
		return 0
	end

	if HonorPoint < 40 then
		SystemNotice ( role , "Тебе необходимо 40 очков Чести для входа в Баунти ПК. " )
		return 0
	end

	if HonorPoint >30000 then
		SystemNotice ( role , "Слишком много Очков Чести для входа в Баунти ПК " )
		return 0
	end

	local Credit_Garner2 = GetCredit(role)
	 if Credit_Garner2 < 80 then 
		SystemNotice ( role , "Тебе необходимо 80 очков репутации для входа в Баунти ПК. " )
		return 0
	end

	local Cha = TurnToCha(role)
  	if Lv(Cha) >=65 and Lv(Cha) <=100 then
		return 1
	else
		SystemNotice(role, "Только персонажи с 65 до 100 уровня могут посещать Баунти ПК.")
		return 0    
	end

	local Has_money = check_HasMoney(role)
	if Has_money == 1 then
		
		return 1
		
	else
		SystemNotice(role,"У Вас нет достаточно денег для входа в Баунти ПК ")
		return 0
	end

	if FightingBook_Num <= 0 then
		SystemNotice ( role , "У вас нет Медали Отваги, без неё вход в Баунти ПК невозможен.")
		return 0
	elseif FightingBook_Num > 1 then
		SystemNotice ( role , "Да вы, батенька, читер!!!")
		return 0
	end
end


function check_HasMoney(role)
	local lv= GetChaAttr(role, ATTR_LV)
	local Money_Need = lv*50
	local Money_Have = GetChaAttr ( role , ATTR_GD )
		if Money_Have >= Money_Need then
			return 1
		end

end

function begin_enter_bountypk(role, copy_mgr) 
	local	Money_Have = GetChaAttr ( role , ATTR_GD )
	local lv= GetChaAttr(role, ATTR_LV)
	local Money_Need = lv*50
	local	Money_Now = Money_Have - Money_Need
	SetChaAttrI( role , ATTR_GD , Money_Now )
	DelCredit(role,30)
		SystemNotice(role,"У вас взяли "..Money_Need.." золота, и 30 очков репутации. ") 
		MoveCity(role, "Bounty Hunter PK")
Money_all = Money_all + Money_Need * 0.8
end