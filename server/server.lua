MVS_C = exports["maV_core"]:getSharedObject()


local maV_Shops = {}

ShopsData = LoadResourceFile(GetCurrentResourceName(), "./data/shops.json") 
maV_Shops = json.decode(ShopsData)


TruckData = LoadResourceFile(GetCurrentResourceName(), "./data/truck.json") 
maV_Truck = json.decode(TruckData)


MVS_C.RegisterServerCallback("maV-shops:GetTime", function(source, data, cb)
    cb(os.time())
end)


MVS_C.RegisterServerCallback("maV-shops:server:Buy_Shops", function(source, data, cb)
    local dd = data[1]
    local b = data[2]
    print(json.encode(b))

    local src = source
    local xPlayer = MVS_C.GetPlayer(src)
    local money = 0
    local identifier = xPlayer.identifier
    dd.Identifier = identifier
    if MVS.Shops_Buy_Money == "bank" then money = xPlayer.getBank() else money = xPlayer.getMoney() end
    print(money)
    if maV_Shops[MVS.Zones.Shops[b].Pos.number] == nil then
        if money >= MVS.Zones.Shops[b].Price then
            maV_Shops[MVS.Zones.Shops[b].Pos.number] = dd
           
            if MVS.Shops_Buy_Money == "bank" then  xPlayer.removeBank(MVS.Zones.Shops[b].Price) else  xPlayer.removeMoney(MVS.Zones.Shops[b].Price) end
            
            SaveResourceFile(GetCurrentResourceName(), "./data/shops.json", json.encode(maV_Shops, { indent = true }), -1)
            TriggerClientEvent('maV-shops:client:Sync', -1, maV_Shops, dd)
            TriggerClientEvent('maV-shops:client:SourceSync', src, maV_Shops, identifier)

            cb(true)
        else
            cb(false)
        end

    end

end)


RegisterNetEvent('maV-shops:server:LoginSourceSync', function()
    local src = source
    local xPlayer = MVS_C.GetPlayer(src)
    local identifier = xPlayer.identifier
    TriggerClientEvent('maV-shops:client:SourceSync', src, maV_Shops, identifier)


end)


MVS_C.RegisterServerCallback('maV-shops:Wholesaler_Truck_All_Check', function(source, data, cb)
    local src = source
    local xPlayer = MVS_C.GetPlayer(src)
    local identifier = xPlayer.identifier
    local money = 0    
    local totalprice = data[1]
    local cart = data[2]
    local time = os.time()
    print(totalprice)
    if MVS.Wholesaler_Buy_Money == "bank" then money = xPlayer.getBank() else money = xPlayer.getMoney() end
    if money >= tonumber(totalprice) then
        if maV_Truck[identifier] == nil then maV_Truck[identifier] = {}  end
        for k,v in pairs(cart) do
            table.insert(maV_Truck[identifier], {
                item_Name = v.item_Name,
                item_Label = v.item_Label,
                item_Price = v.item_Price,
                item_Count = v.item_Count,
                item_Time = time
            })

        end
        if MVS.Wholesaler_Buy_Money == "bank" then  xPlayer.removeBank(totalprice) else  xPlayer.removeMoney(totalprice) end
        SaveResourceFile(GetCurrentResourceName(), "./data/truck.json", json.encode(maV_Truck, { indent = true }), -1)

        cb(true)
    else
        cb(false)
    end


end)



MVS_C.RegisterServerCallback('maV-shops:Wholesaler_Truck_Check', function(source, data, cb)
    local src = source
    local xPlayer = MVS_C.GetPlayer(src)
    local identifier = xPlayer.identifier
    local money = 0    
    local a = data[1]
    local totalprice = (a.item_Count*a.item_Price)

    if MVS.Wholesaler_Buy_Money == "bank" then money = xPlayer.getBank() else money = xPlayer.getMoney() end
    if money >= tonumber(totalprice) then
        if maV_Truck[identifier] == nil then maV_Truck[identifier] = {} end
        table.insert(maV_Truck[identifier], {
            item_Name = a.item_Name,
            item_Label = a.item_Label,
            item_Price = a.item_Price,
            item_Count = a.item_Count,
            item_Time = os.time()
        })
        if MVS.Wholesaler_Buy_Money == "bank" then  xPlayer.removeBank(totalprice) else  xPlayer.removeMoney(totalprice) end
        SaveResourceFile(GetCurrentResourceName(), "./data/truck.json", json.encode(maV_Truck, { indent = true }), -1)

        cb(true)
    else
        cb(false)
    end


end)


MVS_C.RegisterServerCallback('maV-shops:Truck_Check', function(source, data, cb)
    local src = source
    local xPlayer = MVS_C.GetPlayer(src)
    local identifier = xPlayer.identifier

    cb({maV_Truck[identifier], os.time()})
end)


MVS_C.RegisterServerCallback('maV-shops:Truck_Complated', function(source, data, cb)
    local src = source
    local xPlayer = MVS_C.GetPlayer(src)
    local identifier = xPlayer.identifier

    local shops = data[1]
    local time = os.time()

    if #maV_Truck[identifier] > 0 then
        for k,v in pairs(maV_Truck[identifier]) do
            if time - v.item_Time >= 1900 then 
                print(v.item_Name)
                if maV_Shops[shops].Shops_Stash[v.item_Name] ~= nil then
                    maV_Shops[shops].Shops_Stash[v.item_Name].item_Count = (v.item_Count+maV_Shops[shops].Shops_Stash[v.item_Name].item_Count)
                else
                    maV_Shops[shops].Shops_Stash[v.item_Name] = {
                        item_Name = v.item_Name,
                        item_Label = v.item_Label,
                        item_Count = v.item_Count,
                    }
                end
                maV_Truck[identifier][k] = nil
                
           
            end
        end
        SaveResourceFile(GetCurrentResourceName(), "./data/truck.json", json.encode(maV_Truck, { indent = true }), -1)

        SaveResourceFile(GetCurrentResourceName(), "./data/shops.json", json.encode(maV_Shops, { indent = true }), -1)

        cb(true)
    
    end


end)

MVS_C.RegisterServerCallback('maV-shops:GetProducts', function(source, data, cb)
    local src = source
    local xPlayer = MVS_C.GetPlayer(src)
    local identifier = xPlayer.identifier


    local shops = maV_Shops[data[1]]

    cb(shops)
end)


MVS_C.RegisterServerCallback('maV-shops:Shops_Confirm_Cart', function(source, data, cb)
    local src = source
    local xPlayer = MVS_C.GetPlayer(src)
    local identifier = xPlayer.identifier

    local cart = data[1]
    local cashorbank = data[2]
    local shopsid = data[3]
  
    local totalprice = 0
    local money = 0
    for k,v in pairs(cart) do
        totalprice = totalprice + (v.item_SellPrice*v.item_Amount)
    end
    if cashorbank == "bank" then money = xPlayer.getBank() else money = xPlayer.getMoney() end
    if money >= totalprice then
        stokitem = {}

        for k,v in pairs(cart) do
            if maV_Shops[tonumber(shopsid.Pos.number)].Shops_Items[v.item_Name].item_Count >= v.item_Amount then
                itemamountsellprice = v.item_Amount*maV_Shops[tonumber(shopsid.Pos.number)].Shops_Items[v.item_Name].item_SellPrice
                local secur = maV_Shops[tonumber(shopsid.Pos.number)].Shops_Items[v.item_Name].item_Count - v.item_Amount
                if secur >= 0 then
                    if money >= itemamountsellprice then
                        TriggerClientEvent('maV-shops:Notification', src, {
                            "Complated", 
                            v.item_Label.." product purchased. $"..itemamountsellprice,
                            "success"
                        })

                        if cashorbank == "bank" then  xPlayer.removeBank(itemamountsellprice) else  xPlayer.removeMoney(itemamountsellprice) end
                        xPlayer.addItem(v.item_Name, v.item_Amount, nil, nil)
                        maV_Shops[tonumber(shopsid.Pos.number)].Shops_Items[v.item_Name].item_Count = secur
                        maV_Shops[tonumber(shopsid.Pos.number)].Shops_Safe_Money = maV_Shops[tonumber(shopsid.Pos.number)].Shops_Safe_Money + itemamountsellprice
                        if maV_Shops[tonumber(shopsid.Pos.number)].Shops_Items[v.item_Name].item_Count <= 0 then maV_Shops[tonumber(shopsid.Pos.number)].Shops_Items[v.item_Name] = nil end
                    else
                        TriggerClientEvent('maV-shops:Notification', src, {
                            "Error", 
                            "You don't have enough money for "..v.item_Label.." products.",
                            "error"
                        })
                    end
                end
            end
        end
        SaveResourceFile(GetCurrentResourceName(), "./data/shops.json", json.encode(maV_Shops, { indent = true }), -1)

        cb(true)

    else
        cb(false)
    end



end)

MVS_C.RegisterServerCallback('maV-shops:GetShopSafeMoney', function(source, data, cb)
    local src = source
    local xPlayer = MVS_C.GetPlayer(src)
    local identifier = xPlayer.identifier

    local shops = data[2]
    local shopid = tonumber(shops.Pos.number)

    local datashops = maV_Shops[shopid]
    if datashops.Identifier == identifier then
       cb(datashops.Shops_Safe_Money) 
    else
        cb(false)
    end

end)


MVS_C.RegisterServerCallback('maV-shops:Deposit_Money', function(source, data, cb)
    local src = source
    local xPlayer = MVS_C.GetPlayer(src)
    local identifier = xPlayer.identifier

    local money = xPlayer.getMoney()

    local shops = data[2]
    local shopid = tonumber(shops.Pos.number)

    local datashops = maV_Shops[shopid]
    local amountprice = tonumber(data[3])

    if datashops.Identifier == identifier and amountprice > 0 then
        if money >= amountprice then
            datashops.Shops_Safe_Money = datashops.Shops_Safe_Money + amountprice 
            SaveResourceFile(GetCurrentResourceName(), "./data/shops.json", json.encode(maV_Shops, { indent = true }), -1)
            xPlayer.removeMoney(amountprice)
            cb(true)
        else
            TriggerClientEvent('maV-shops:Notification', src, {
                "Error",
                "You don't have enough money.",
                "error"
            })
            cb(false)
        end
    else
        cb(false)
    end


end)


MVS_C.RegisterServerCallback('maV-shops:Withdraw_Money', function(source, data, cb)
    local src = source
    local xPlayer = MVS_C.GetPlayer(src)
    local identifier = xPlayer.identifier

    local money = xPlayer.getMoney()

    local shops = data[2]
    local shopid = tonumber(shops.Pos.number)



    local datashops = maV_Shops[shopid]
    local shopprice = datashops.Shops_Safe_Money
    local amountprice = tonumber(data[3])

    if datashops.Identifier == identifier and amountprice > 0 then
        if shopprice >= amountprice then
            datashops.Shops_Safe_Money = datashops.Shops_Safe_Money - amountprice 
            SaveResourceFile(GetCurrentResourceName(), "./data/shops.json", json.encode(maV_Shops, { indent = true }), -1)
            xPlayer.addMoney(amountprice)
            cb(true)
        else
            TriggerClientEvent('maV-shops:Notification', src, {
                "Error",
                "You don't have enough money.",
                "error"
            })
            cb(false)
        end
    else
        cb(false)
    end


end)


MVS_C.RegisterServerCallback('maV-shops:GetInventory', function(source, data, cb)
    local src = source
    local xPlayer = MVS_C.GetPlayer(src)
    local identifier = xPlayer.identifier

    local inventory = xPlayer.inventory

    cb(inventory)

end)


MVS_C.RegisterServerCallback('maV-shops:PutItem', function(source, data, cb)
    local src = source
    local xPlayer = MVS_C.GetPlayer(src)
    local identifier = xPlayer.identifier

    local shops = data[2]
    local shopid = tonumber(shops.Pos.number)

    local itemInfo = data[3]
    local itemAmount = data[4]
    local itemCount = 0

    local datashops = maV_Shops[shopid]
    if itemInfo.count ~= nil then itemCount = itemInfo.count else itemCount = itemInfo.amount end
    if datashops.Identifier == identifier and itemAmount > 0 and itemCount >= itemAmount then
        if datashops.Shops_Stash[itemInfo.name] ~= nil then
            datashops.Shops_Stash[itemInfo.name].item_Count = datashops.Shops_Stash[itemInfo.name].item_Count + itemAmount
        else
            datashops.Shops_Stash[itemInfo.name] = {
                item_Label = itemInfo.label,
                item_Name = itemInfo.name,
                item_Count = itemAmount,
            }
        end
        xPlayer.removeItem(itemInfo.name, itemAmount, nil, nil)
        SaveResourceFile(GetCurrentResourceName(), "./data/shops.json", json.encode(maV_Shops, { indent = true }), -1)
        cb(true)
    else
        cb(false)
    end
end)


MVS_C.RegisterServerCallback('maV-shops:GetShopStash', function(source, data, cb)
    local src = source
    local xPlayer = MVS_C.GetPlayer(src)
    local identifier = xPlayer.identifier

    local shops = data[2]
    local shopid = tonumber(shops.Pos.number)

    local datashops = maV_Shops[shopid]

    if datashops.Identifier == identifier then
        if datashops.Shops_Stash == nil then
            datashops.Shops_Stash = {}
        end
        cb(datashops.Shops_Stash)
    end
    

end)

MVS_C.RegisterServerCallback('maV-shops:StashItemGet', function(source, data,cb)
    local src = source
    local xPlayer = MVS_C.GetPlayer(src)
    local identifier = xPlayer.identifier

    local shops = data[2]
    local shopid = tonumber(shops.Pos.number)

    local datashops = maV_Shops[shopid]
    local item = data[3]

    local getitemamount = tonumber(data[4])

    if datashops.Identifier == identifier then
        if datashops.Shops_Stash[item.item_Name] ~= nil and datashops.Shops_Stash[item.item_Name].item_Count >= getitemamount then
            kk = datashops.Shops_Stash[item.item_Name].item_Count - getitemamount

            if kk >= 0 then
                if kk == 0 then datashops.Shops_Stash[item.item_Name] = nil else datashops.Shops_Stash[item.item_Name].item_Count = kk end
                
                xPlayer.addItem(item.item_Name, getitemamount, nil, nil)
                SaveResourceFile(GetCurrentResourceName(), "./data/shops.json", json.encode(maV_Shops, { indent = true }), -1)
                cb(true)

            end


        end
    end

end)

MVS_C.RegisterServerCallback('maV-shops:StashSellItem', function(source, data, cb)
    local src = source
    local xPlayer = MVS_C.GetPlayer(src)
    local identifier = xPlayer.identifier

    local shops = data[2]
    local shopid = tonumber(shops.Pos.number)

    local datashops = maV_Shops[shopid]
    local item = data[3]

    local itemAmount = data[4]
    local itemPrice = data[5]

    if datashops.Identifier == identifier then
        if datashops.Shops_Stash[item.item_Name] ~= nil and datashops.Shops_Stash[item.item_Name].item_Count >= itemAmount then
            kk = datashops.Shops_Stash[item.item_Name].item_Count - itemAmount
            if kk >= 0 then
                if datashops.Shops_Items[item.item_Name] ~= nil then
                    datashops.Shops_Items[item.item_Name].item_Count = datashops.Shops_Items[item.item_Name].item_Count + itemAmount
                    datashops.Shops_Items[item.item_Name].item_SellPrice = itemPrice

                else
                    datashops.Shops_Items[item.item_Name] = {
                        item_Name = item.item_Name,
                        item_Label = item.item_Label,
                        item_Count = itemAmount,
                        item_SellPrice = itemPrice
                    }
                end
                if kk == 0 then datashops.Shops_Stash[item.item_Name] = nil else datashops.Shops_Stash[item.item_Name].item_Count = kk end
                SaveResourceFile(GetCurrentResourceName(), "./data/shops.json", json.encode(maV_Shops, { indent = true }), -1)
                cb(true)
            end
        end
    end

end)

MVS_C.RegisterServerCallback('maV-shops:ProductsSale', function(source, data, cb)
    local src = source
    local xPlayer = MVS_C.GetPlayer(src)
    local identifier = xPlayer.identifier

    local shops = data[2]
    local shopid = tonumber(shops.Pos.number)

    local datashops = maV_Shops[shopid]

    if datashops.Identifier == identifier then
        cb(datashops.Shops_Items)
    end
    
end)

MVS_C.RegisterServerCallback('maV_shops:RemoveProductItem', function(source, data, cb)
    local src = source
    local xPlayer = MVS_C.GetPlayer(src)
    local identifier = xPlayer.identifier

    local shops = data[2]
    local shopid = tonumber(shops.Pos.number)

    local datashops = maV_Shops[shopid]

    local item = data[3]
    local itemAmount = tonumber(data[4])



    if datashops.Identifier == identifier then
        kk = datashops.Shops_Items[item.item_Name].item_Count - itemAmount

        if datashops.Shops_Items[item.item_Name].item_Count >= itemAmount then
            if datashops.Shops_Stash[item.item_Name] ~= nil then
                datashops.Shops_Stash[item.item_Name].item_Count = datashops.Shops_Stash[item.item_Name].item_Count + itemAmount 
            else
                datashops.Shops_Stash[item.item_Name] = {
                    item_Name = item.item_Name,
                    item_Count = itemAmount,
                    item_Label = item.item_Label
                }
            end
            if kk == 0 then datashops.Shops_Items[item.item_Name] = nil else datashops.Shops_Items[item.item_Name].item_Count = kk end
            SaveResourceFile(GetCurrentResourceName(), "./data/shops.json", json.encode(maV_Shops, { indent = true }), -1)
            cb(true)

        end
    end
end)


MVS_C.RegisterServerCallback('maV-shops:ChangePrice', function(source, data, cb)
    local src = source
    local xPlayer = MVS_C.GetPlayer(src)
    local identifier = xPlayer.identifier

    local shops = data[2]
    local shopid = tonumber(shops.Pos.number)

    local datashops = maV_Shops[shopid]

    local item = data[3]
    local changePrice = data[4]

    if datashops.Identifier == identifier and changePrice > 0 then
        datashops.Shops_Items[item.item_Name].item_SellPrice = changePrice
        
        SaveResourceFile(GetCurrentResourceName(), "./data/shops.json", json.encode(maV_Shops, { indent = true }), -1)
        cb(true)
    end
end)

MVS_C.RegisterServerCallback('maV-shops:ChangeName', function(source, data, cb)
    local src = source
    local xPlayer = MVS_C.GetPlayer(src)
    local identifier = xPlayer.identifier

    local shops = data[2]
    local shopid = tonumber(shops.Pos.number)

    local datashops = maV_Shops[shopid]

    local shopnewname = data[3]

    local money = 0
    if MVS.Shops_Change_Name_Money[1] == "bank" then money = xPlayer.getBank() else money = xPlayer.getMoney() end

    if datashops.Identifier == identifier then
        if money >= MVS.Shops_Change_Name_Money[2] then
            datashops.Name = shopnewname
            if MVS.Shops_Change_Name_Money[1] == "bank" then  xPlayer.removeBank(MVS.Shops_Change_Name_Money[2]) else  xPlayer.removeMoney(MVS.Shops_Change_Name_Money[2]) end

            SaveResourceFile(GetCurrentResourceName(), "./data/shops.json", json.encode(maV_Shops, { indent = true }), -1)
            TriggerClientEvent('maV-shops:client:Sync', -1, maV_Shops)
            cb(true)
        else
            TriggerClientEvent('maV-shops:Notification', src, {
                "Error",
                "You don't have enough money.",
                "error"
            })
        end

    end

end)