MVS_C = exports["maV_core"]:getSharedObject()




MVS_LOCAL = {
    cart = {},
    owned_shops = {},
    truck = {
        {
            item_Name = "phone",
            item_Label = "Phone",
            item_Price = 123,
            item_Count = 12,
            item_Time = 123
        },
        {
            item_Name = "tab",
            item_Label = "TAB",
            item_Price = 123,
            item_Count = 12,
            item_Time = 123
        }
    },
    succestruck = {},
    all_blips = {},
    product_cart = {}
}


local showblip, number = false, nil
local Cart, AllBlips, displayedBlips,PlayerData = {}, {}, {}, {}  




local marketId = 0



Citizen.CreateThread(function()

	-- firstLogin()
end)



-- maV-core Ped Create
Citizen.CreateThread(function()
	exports["maV_core"]:pedcreate("Store-Purchasing",  MVS.Zones.Store_Purchasing.ped, MVS.Zones.Store_Purchasing.coords.x, MVS.Zones.Store_Purchasing.coords.y, MVS.Zones.Store_Purchasing.coords.z - 1,  MVS.Zones.Store_Purchasing.coords.h)
	exports["maV_core"]:pedcreate("Wholesaler",  MVS.Zones.Wholesaler.ped, MVS.Zones.Wholesaler.coords.x, MVS.Zones.Wholesaler.coords.y, MVS.Zones.Wholesaler.coords.z - 0.9,  MVS.Zones.Wholesaler.coords.h)



    for k,v in pairs(MVS.Zones.Shops) do
        exports["maV_core"]:pedcreate("Shops"..v.Pos.number,  v.Ped, v.PedPos.x, v.PedPos.y, v.PedPos.z - 0.9,  v.PedPos.h)
    end
end)

CreateThread(function()

    TriggerServerEvent('maV-shops:server:LoginSourceSync')

    local Wholesaler = AddBlipForCoord(vector3(MVS.Zones.Wholesaler.coords.x, MVS.Zones.Wholesaler.coords.y, MVS.Zones.Wholesaler.coords.z))
    SetBlipSprite(Wholesaler, MVS.Zones.Wholesaler.blip.sprite)
    SetBlipDisplay(Wholesaler, 4)
    SetBlipScale(Wholesaler, MVS.Zones.Wholesaler.blip.scale)
    SetBlipColour(Wholesaler, MVS.Zones.Wholesaler.blip.colour)
    SetBlipAsShortRange(Wholesaler, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(MVS.Zones.Wholesaler.blip.name)
    EndTextCommandSetBlipName(Wholesaler)



    local Store_Purchasing = AddBlipForCoord(MVS.Zones.Store_Purchasing.coords.x, MVS.Zones.Store_Purchasing.coords.y, MVS.Zones.Store_Purchasing.coords.z)

    SetBlipSprite(Store_Purchasing, MVS.Zones.Store_Purchasing.blip.sprite)
    SetBlipDisplay(Store_Purchasing, 4)
    SetBlipScale(Store_Purchasing, MVS.Zones.Store_Purchasing.blip.scale)
    SetBlipColour(Store_Purchasing, MVS.Zones.Store_Purchasing.blip.colour)
    SetBlipAsShortRange(Store_Purchasing, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(MVS.Zones.Store_Purchasing.blip.name)
    EndTextCommandSetBlipName(Store_Purchasing)

    
    Create_Refresh_Blip()


    while true do
        wait = 2000
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)

        if #(pedCoords - vector3( MVS.Zones.Store_Purchasing.coords.x, MVS.Zones.Store_Purchasing.coords.y, MVS.Zones.Store_Purchasing.coords.z)) < 4 then
            wait = 1
            local text = MVS.Zones.Store_Purchasing.blip.name
            if #(pedCoords - vector3( MVS.Zones.Store_Purchasing.coords.x, MVS.Zones.Store_Purchasing.coords.y, MVS.Zones.Store_Purchasing.coords.z)) < 1.5 then
                text = "[E] "..text
                if IsControlJustReleased(1, 51)  then
                   Open_Store_Purchasing()
                end
            end
            DrawText3D(MVS.Zones.Store_Purchasing.coords.x, MVS.Zones.Store_Purchasing.coords.y, MVS.Zones.Store_Purchasing.coords.z + 1, text)
        end


        if #(pedCoords - vector3(MVS.Zones.Wholesaler.coords.x, MVS.Zones.Wholesaler.coords.y, MVS.Zones.Wholesaler.coords.z)) < 4 then
            wait = 1
            local text = MVS.Zones.Wholesaler.blip.name
            if #MVS_LOCAL.owned_shops > 0 then
                if #(pedCoords - vector3( MVS.Zones.Wholesaler.coords.x, MVS.Zones.Wholesaler.coords.y, MVS.Zones.Wholesaler.coords.z)) < 1.5 then
                    text = "[E] "..text
                    if IsControlJustReleased(1, 51)  then
                    Open_Wholesaler()
                    end
                end
            else
                text = "You Can't Reach Without Your Shop"
            end
            DrawText3D(MVS.Zones.Wholesaler.coords.x, MVS.Zones.Wholesaler.coords.y, MVS.Zones.Wholesaler.coords.z + 1, text)
        end

        for k,v in pairs(MVS.Zones.Shops) do 
            if #(pedCoords - vector3( v.Pos.x, v.Pos.y, v.Pos.z)) < 4 then
                wait = 1
                local text = ""
                if v.Name ~= nil then
                    text = v.Name
                else
                    text = 'Shops '..v.Pos.number
                end
                if #(pedCoords - vector3( v.Pos.x, v.Pos.y, v.Pos.z)) < 1.5 then
                    text = "[E] "..text
                    if IsControlJustReleased(1, 51)  then
                        Open_Shop(k,v)
                    end
                end
           
                DrawText3D(v.Pos.x, v.Pos.y, v.Pos.z + 1, text)
            end
        end

        Wait(wait)
    end
end)


Create_Refresh_Blip = function()

    if #MVS_LOCAL.all_blips > 0 then
        for i=1, #MVS_LOCAL.all_blips do
            RemoveBlip(MVS_LOCAL.all_blips[i])	
        end
        MVS_LOCAL.all_blips = {}
    end
   

    for k,v in pairs(MVS.Zones.Shops) do
		name = ""
		
		if v.Name ~= nil then
			name = v.Name
		else
			name = 'Shops '..v.Pos.number
		end
		
		local blip = AddBlipForCoord(vector3(v.Pos.x, v.Pos.y, v.Pos.z))
		SetBlipSprite (blip, 52)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.5)
		SetBlipColour (blip, 69)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(name)
		EndTextCommandSetBlipName(blip)
		table.insert(MVS_LOCAL.all_blips, blip)

		
				
	end
end

RegisterNetEvent('maV-shops:client:Sync', function(dd, m)

    for k, v in pairs(dd) do
        MVS.Zones.Shops[v.Pos.number].Identifier = v.Identifier
        MVS.Zones.Shops[v.Pos.number].Name = v.Name
    end

    Create_Refresh_Blip()
end)

RegisterNetEvent('maV-shops:client:SourceSync', function(dd, identifier)

    for k, v in pairs(dd) do
        print(v.Pos.number)
        if identifier == v.Identifier then
         
            MVS_LOCAL.owned_shops[v.Pos.number] = v
        end
        MVS.Zones.Shops[v.Pos.number].Identifier = v.Identifier
        MVS.Zones.Shops[v.Pos.number].Name = v.Name
    end
    Create_Refresh_Blip()

end)


RegisterNetEvent('maV-core:playerLoaded', function()

end)





  
Open_Store_Purchasing = function()

    local options = {}

    for i=1, #MVS.Zones.Shops, 1 do
        kk = MVS.Zones.Shops[i]
        
        if kk.Identifier ~= nil then
            print(kk.Identifier)
            table.insert(options, {
                title = kk.Name,
                description = 'Not for Sale Owned',
                icon = kk.Icon,
                disabled = true,
            })

        else
            table.insert(options, {
                title = 'Shops '..kk.Pos.number,
                description = 'Shops Fee $'..kk.Price,
                icon = kk.Icon,
                onSelect = function()
                    Store_Purchasing_Confirmation(i)
                end
            })
        end
      
    end
    lib.registerContext({
        id = 'store_purchasing',
        title = MVS.Zones.Store_Purchasing.blip.name,
        options = options
    })

    lib.showContext('store_purchasing')
 
    
end
Store_Purchasing_Confirmation = function(b)
  
    lib.registerContext({
        id = 'purchasing_confirmation',
        title = 'Shops '..b,
        menu = 'store_purchasing',
        onBack = function()
            Open_Store_Purchasing()
        end,
        options = {
            {
                title = 'Buy Now $'.. MVS.Zones.Shops[b].Price,
                icon = 'check',
                onSelect = function()
                    Store_Name(b)
                end,
                
            },
            {
                title = 'Cancel',
                icon = 'x',
                onSelect = function()
                    Open_Store_Purchasing()
                end,
               
            },
        }
    })
    lib.showContext('purchasing_confirmation')
end
Store_Name = function(b)
    local input = lib.inputDialog('Store Name', {
        {type = 'input', label = 'Store Name',  required = true, min = 4, max = 25, icon = 'hashtag'},
        {type = 'checkbox', label = 'I am sure I spelled my store name correctly.',  required = true},
    })
    
    if not input then 
        return Open_Store_Purchasing()
    else
        data = {
            {
                Identifier = "",
                Pos = MVS.Zones.Shops[b].Pos,
                PedPos = MVS.Zones.Shops[b].PedPos,
                PedLevel = MVS.Zones.Shops[b].PedLevel,
                Icon = MVS.Zones.Shops[b].Icon,
                Price = MVS.Zones.Shops[b].Price,
                Number = MVS.Zones.Shops[b].Pos.number,

                Name = input[1],
                Shops_Safe_Money = 0,
                Shops_Stash = {},
                Shops_Items = {},
            },
            b
            
        }
        
    

        MVS_C.TriggerServerCallback('maV-shops:server:Buy_Shops', data, function(ss)
            if ss then
                MVS.Notify(
                    'Success',
                    "You bought the shop, you can view its location on the map.",
                    'success'
                )
            else
                MVS.Notify(
                    'Error',
                    "You don't have enough money",
                    'error'
                )
            end
            
        end)
        
        

    
    end

end
RegisterCommand('storeshop', function()
    Open_Store_Purchasing()
end)



Open_Wholesaler = function()
    
    lib.registerContext({
        id = 'open_wholesaler',
        title = MVS.Zones.Wholesaler.blip.name,

        options = {
            {
                title = 'Product Purchase',
                icon = 'shop',
                onSelect = function()
                    Open_Wholesaler_Product()
                end,
            },
            {
                title = 'Product Cart',
                icon = 'basket-shopping',
                onSelect = function()
                    Open_Wholesaler_Cart()
                end,
                
            },
            {
                title = 'Check Incoming Products',
                icon = 'truck-fast',
                onSelect = function()
                    Open_Wholesaler_Check()
                end,
               
            },

           
        }
    })
    lib.showContext('open_wholesaler')
end
Open_Wholesaler_Product = function()
    local options = {}

    for k,v in pairs(MVS.Wholesaler_Item) do
        table.insert(options, {
            title = v.item_Label..' $'..v.item_Price,
            icon = 'chevron-right',
            onSelect = function()
                Open_Wholesaler_Product_Add_Cart(v)
            end,
        })
    
      
    end
    lib.registerContext({
        id = 'store_purchasing',
        title = MVS.Zones.Store_Purchasing.blip.name,
        menu = 'open_wholesaler',
        onBack = function()
            Open_Wholesaler()
        end,
        options = options
    })

    lib.showContext('store_purchasing')

end
Open_Wholesaler_Product_Add_Cart = function(v)
    local input = lib.inputDialog('Store Name', {
        {type = 'number', label = 'Product Count',  required = true, min = 1, icon = 'plus'},
    })
    
    if not input then 
        MVS.Notify(
            'Cancel',
            'Product could not be ordered',
            'error'
        )
        return Open_Wholesaler_Product()
    else
        MVS.Notify(
            'Completed',
            'Product added to cart',
            'success'
        )
        table.insert(MVS_LOCAL.cart, {
            item_Name = v.item_Name,
            item_Label = v.item_Label,
            item_Price = v.item_Price,
            item_Count = input[1]

        })
        return Open_Wholesaler_Product()
    end
end
Open_Wholesaler_Cart = function()
    local dd = {}
    totalprice = 0
    for k,v in pairs(MVS_LOCAL.cart) do
        totalprice = totalprice+(v.item_Count*v.item_Price)
    end
    local options = {
        {
            title = 'Confirm Cart $'..totalprice,
            icon = 'check',
            onSelect = function()
                Add_Wholesaler_Truck_All(totalprice)
                MVS.Notify(
                    'Confirm',
                    'All items in the cart have been ordered.',
                    'success'
                )
            end,
        },
        {
            title = 'Clear Cart',
            icon = 'x',
            onSelect = function()
                MVS.Notify(
                    'Delete',
                    'Products deleted from cart.',
                    'info'
                )
                MVS_LOCAL.cart = {}
                Open_Wholesaler_Cart()
            end,
        },
        {
            title = '',
            icon = '',
            disabled = true,
        
        },
    }

    for k,v in pairs(MVS_LOCAL.cart) do
        table.insert(options, {
            title = v.item_Label..' '..v.item_Count..' x $'..v.item_Price..' = $'..(v.item_Count*v.item_Price),
            icon = 'chevron-right',
            onSelect = function()
                Open_Wholesaler_Cart_Product(k, v)
            end,
        })
    end
    
    lib.registerContext({
        id = 'cart',
        title = 'Product Cart',
        menu = 'open_wholesaler',
        onBack = function()
            Open_Wholesaler()
        end,
        options = options
    })

    lib.showContext('cart')
end
Open_Wholesaler_Cart_Product = function(k,a)
   
    lib.registerContext({
        id = 'product_cart_details',
        title = a.item_Label..' '..a.item_Count..' x $'..a.item_Price..' = $'..(a.item_Count*a.item_Price),
        menu = 'cart',
        onBack = function()
            Open_Wholesaler_Cart()
        end,
        options = {
            {
                title = 'Delete Product',
                icon = 'trash',
                onSelect = function()
                    table.remove(MVS_LOCAL.cart, k)
                    Open_Wholesaler_Cart()
                    MVS.Notify(
                        'Delete',
                        'Product removed from cart',
                        'info'
                    )
                end,
            },
            {
                title = 'Order Now',
                icon = 'truck-fast',
                onSelect = function()
                    
                    Open_Wholesaler_Cart()
                    Add_Wholesaler_Truck(k, a)
                    MVS.Notify(
                        'On the way...',
                        'The product has been ordered. On the way...',
                        'success'
                    )
                end,
            },
        }
    })
    lib.showContext('product_cart_details')
end
Add_Wholesaler_Truck_All = function(totalprice)

    MVS_C.TriggerServerCallback('maV-shops:Wholesaler_Truck_All_Check', {totalprice, MVS_LOCAL.cart}, function(d)
        if d then
            MVS.Notify(
                'Confirm',
                'All orders have been paid for. In the cargo...',
                'success'
            )
            MVS_LOCAL.cart = {} 
            Open_Wholesaler_Cart()
        else
            MVS.Notify(
                'Error',
                "You don't have enough money.",
                'error'
            )
            Open_Wholesaler_Cart()
        end
        
    end)


    
 
end
Add_Wholesaler_Truck = function(k,a)

    MVS_C.TriggerServerCallback('maV-shops:Wholesaler_Truck_Check', {a}, function(d)
        if d then
            MVS.Notify(
                'On the way...',
                'The product has been ordered. On the way...',
                'success'
            )
            table.remove(MVS_LOCAL.cart, k)
            Open_Wholesaler_Cart()
        else
            MVS.Notify(
                'Error',
                "You don't have enough money.",
                'error'
            )
            Open_Wholesaler_Cart()
        end
        
    end)

end
Open_Wholesaler_Check = function()
    MVS_C.TriggerServerCallback("maV-shops:Truck_Check", {}, function(data)
  
        

        local options = {
            {
                title = "Send ready orders to the shop warehouse.",
                icon = 'truck-fast',
                onSelect = function()
                    if #data[1] > 0 then
                        ReadyWareHouse(data[2])
                    else
                        MVS.Notify(
                            'Error',
                            "No ready product found.",
                            'error'
                        )
                        Open_Wholesaler_Check()
                    end
                end,
            },
            {
                title = '',
                icon = '',
                disabled = true,
            
            },
        }

        for k,v in pairs(data[1]) do
            if data[2] - v.item_Time >= 1900 then 
                times = data[2] - v.item_Time
                table.insert(options, {
                    title = v.item_Label..' READY',
                    icon = 'check',
                    onSelect = function()
                        
                        Open_Wholesaler_Check()
                    end,
                })
            end
        end
        table.insert(options, {
            title = '',
            icon = '',
            disabled = true,
        })
        for k,v in pairs(data[1]) do
            times = data[2] - v.item_Time
            if times < 1900 then 
                table.insert(options, {
                    title = v.item_Label..' time remaining: '.. math.floor((1900 - times) / 60) ..' min.',
                    icon = 'chevron-right',
                    onSelect = function()
                        MVS.Notify(
                            'Info',
                            "Your order's "..math.floor((1900 - times) / 60).. " minutes away.",
                            'info'
                        )
                        Open_Wholesaler_Check()
                    end,
                })
            end
        end
        
        lib.registerContext({
            id = 'ddddd',
            title = 'Cargo Shipments',
            menu = 'open_wholesaler',
            onBack = function()
                Open_Wholesaler()
            end,
            options = options
        })

        lib.showContext('ddddd')
    end)
end
ReadyWareHouse = function(time)
    local options = {}
    for s,t in pairs(MVS_LOCAL.owned_shops) do
        table.insert(options, {
            title = t.Name,
            icon = t.Icon,
            onSelect = function()
                ReadyProductSentShops(s, time)
            end,
        })
    end


    lib.registerContext({
        id = 'all_my_shops',
        title = "Which Shop's Warehouse should it be sent to?",
        menu = 'ddddd',
        onBack = function()
            Open_Wholesaler_Check()
        end,
        options = options
    })
    lib.showContext('all_my_shops')
end
ReadyProductSentShops = function(shops, time)

    MVS_C.TriggerServerCallback('maV-shops:Truck_Complated', {shops}, function(ddd)
        if ddd then
            MVS.Notify(
                'Complated',
                "Products were sent to the "..MVS.Zones.Shops[shops].Name.." shop. ",
                'success'
            )

        end
    
    end)

    

end
RegisterCommand('toptan', function()
    Open_Wholesaler()

end)


Open_Shop = function(a,b)
    name = ""
		
    if b.Name ~= nil then
        name = b.Name
    else
        name = 'Shops '..b.Pos.number
    end
    options = {
        {
            title = 'Buy Product',
            icon = 'shop',
            onSelect = function()
                Open_Shop_Product(a,b)
            end,
        },
        {
            title = 'Product Cart',
            icon = 'basket-shopping',
            onSelect = function()
                Open_Shop_Cart(a,b)
            end,
            
        },           
    }

    if MVS_LOCAL.owned_shops[MVS.Zones.Shops[a].Pos.number] ~= nil then
        table.insert(options, {
            {
                title = '',
                icon = '',
            },
        })
        
        table.insert(options, {
            
            title = 'Shop Safe',
            icon = 'cash-register',
            onSelect = function()
                Open_Shop_Safe(a,b)
            end,
            
        })
        table.insert(options, {
            
            title = 'Put Stash Item',
            icon = 'suitcase-rolling',
            onSelect = function()
                Open_Put_Item(a,b)
            end,
        
        })
       
        table.insert(options, {
            
                title = 'Shop Stash',
                icon = 'box',
                onSelect = function()
                    Open_Shop_Stash(a,b)
                end,
            
        })
        table.insert(options, {
            
                title = 'Products on Sale',
                icon = 'basket-shopping',
                onSelect = function()
                    Open_Products_Sale(a,b)
                end,
            
        })
        table.insert(options, {
            
                title = 'Change Shop Name $'..MVS.Shops_Change_Name_Money[2],
                icon = 'signature',
                onSelect = function()
                    Open_Change_Shop_Name(a,b)
                end,
            
        })
    end

    lib.registerContext({
        id = 'open_shop',
        title = name,
        options = options
    })
    lib.showContext('open_shop')

end

Open_Shop_Product = function(a,b)

    name = ""
		
    if b.Name ~= nil then
        name = b.Name
    else
        name = 'Shops '..b.Pos.number
    end
    options = {}

    MVS_C.TriggerServerCallback('maV-shops:GetProducts', {b.Pos.number}, function(kk)
        if kk ~= nil then
            for k,v in pairs(kk.Shops_Items) do

                if MVS_LOCAL.product_cart[v.item_Name] ~= nil then
                    v.item_Count = v.item_Count - MVS_LOCAL.product_cart[v.item_Name].item_Amount
                end
                if (v.item_Count > 0) then
                    table.insert(options, {
                        title = v.item_Label.. " $"..v.item_SellPrice.." Count: "..v.item_Count,
                        icon = 'plus',
                        onSelect = function()
                            Select_Product(a,b,v)
                        end,
                    })
                end
            end

        end

        lib.registerContext({
            id = 'open_shop_product',
            title = name.. " Products",
            menu = 'open_shop',
            onBack = function()
                Open_Shop(a,b)
            end,
            options = options
        })
        lib.showContext('open_shop_product')
    end)

   


end

Select_Product = function(a,b,v)
    local input = lib.inputDialog('Amount of Product to be Purchased', {
        {type = 'number', label = 'Count',  required = true, min = 1, max = tonumber(v.item_Count), icon = 'plus'},
    })
    
    if not input then 
        Open_Shop_Product(a,b)
        MVS.Notify(
            'Erorr',
            "The purchase is canceled.",
            'error'
        )
    else
        if input[1] > 0 then
            if MVS_LOCAL.product_cart[v.item_Name] ~= nil then
                MVS_LOCAL.product_cart[v.item_Name].item_Amount = MVS_LOCAL.product_cart[v.item_Name].item_Amount + input[1] 
            else
                MVS_LOCAL.product_cart[v.item_Name] = {
                    item_Name = v.item_Name,
                    item_Label = v.item_Label,
                    item_Count = v.item_Count,
                    item_SellPrice = v.item_SellPrice,
                    item_Amount = input[1]
                }
            end
            Open_Shop_Product(a,b)
            MVS.Notify(
                'Success',
                "Product added to cart.",
                'success'
            )
        else

            MVS.Notify(
                'Erorr',
                "The purchase is canceled.",
                'error'
            )
        end
       
    end

end

Open_Shop_Cart = function(a,b)
    totalprice = 0
    for k,v in pairs( MVS_LOCAL.product_cart) do
        totalprice = totalprice + (v.item_SellPrice*v.item_Amount)
    end
    
    options = {
        {
            title = 'Confirm Cart $'..totalprice,
            icon = "check",
            onSelect = function()
                if totalprice > 0 then
                    Shop_Confirm_Cart(a,b,totalprice)
                end
            end,
        },
        {
            title = 'Clear Cart',
            icon = "trash",
            onSelect = function()
                MVS_LOCAL.product_cart = {}
                MVS.Notify(
                    'Delete',
                    'Products deleted from cart.',
                    'info'
                )

                Open_Shop_Cart(a,b)
            end,
        },
        {
            title = '',
            icon = "",
        }
        
    }

   
    for k,v in pairs(MVS_LOCAL.product_cart) do
        table.insert(options, {
            title = v.item_Label.. " $"..v.item_SellPrice.." x "..v.item_Amount.. " = $"..v.item_SellPrice*v.item_Amount,
            icon = 'minus',
            onSelect = function()
                MVS_LOCAL.product_cart[v.item_Name] = nil
                Open_Shop_Cart(a,b)
            end,
        })
    end

    lib.registerContext({
        id = 'open_shop_cart',
        title = name.. " Cart",
        menu = 'open_shop',
        onBack = function()
            Open_Shop(a,b)
        end,
        options = options
    })
    lib.showContext('open_shop_cart')


end


Shop_Confirm_Cart = function(a,b,totalprice)

    lib.registerContext({
        id = 'cashorcart',
        title = "Cash or Bank? $"..totalprice,
        menu = 'open_shop_cart',
        onBack = function()
            Open_Shop_Cart(a,b)
        end,
        options = {
            {
                title = "Cash",
                icon = "wallet",
                onSelect = function()
                    Shop_Confirm_Cart_End(a,b,"cash")
                end,
            },
            {
                title = "Bank",
                icon = "credit-card",
                onSelect = function()
                    Shop_Confirm_Cart_End(a,b,"bank")

                end,
            },
        }
    })
    lib.showContext('cashorcart')



    
end

Shop_Confirm_Cart_End = function(a,b,cashorbank)
    MVS_C.TriggerServerCallback('maV-shops:Shops_Confirm_Cart', {MVS_LOCAL.product_cart, cashorbank, b}, function(dd)
        if dd then
            MVS_LOCAL.product_cart = {}
            Open_Shop(a,b)
        else
            MVS.Notify(
                "Error",
                "You don't have enough money to buy all the products!",
                "error"
            )
        end
        
    end)

end



Open_Shop_Safe = function(a,b)
    
    shopsmoney = 0
    MVS_C.TriggerServerCallback('maV-shops:GetShopSafeMoney', {a,b}, function(aa)
        if aa then
            shopsmoney = tonumber(aa)


            lib.registerContext({
                id = 'open_shop_safe',
                title = "Shop Safe",
                menu = 'open_shop',
                onBack = function()
                    Open_Shop(a,b)
                end,
                options = {
                    {
                        title = "Total Money $"..shopsmoney,
                        icon = "cash-register",
                        onSelect = function()
                            Open_Shop_Safe(a,b)
                        end,
                    },
                    {
                        title = '',
                        icon = ''
                    },
                    {
                        title = "Deposit Money",
                        icon = "plus",
                        onSelect = function()
                            Deposit_Money(a,b,shopsmoney)
        
                        end,
                    },
                    {
                        title = "Withdraw Money",
                        icon = "minus",
                        onSelect = function()
                            Withdraw_Money(a,b,shopsmoney)
                        end,
                    },
                   
                }
            })
            lib.showContext('open_shop_safe')
        end
    end)
end

Deposit_Money = function(a,b,shopmoney)
    local input = lib.inputDialog('Deposit Money', {
        {type = 'number', label = 'Amount of Money',  required = true, min = 1, icon = 'dollar-sign'},
        {type = 'checkbox', label = 'I confirm the deposit.',  required = true},
    })


    if not input then
        Open_Shop_Safe(a,b)
    else
        MVS_C.TriggerServerCallback('maV-shops:Deposit_Money', {a,b, input[1]}, function(dd)
            if dd then


                MVS.Notify(
                    "Success",
                    "Deposit successful.",
                    "success"
                )
                Open_Shop_Safe(a,b)
            else
                Open_Shop_Safe(a,b)
            end
        end)
    end

end

Withdraw_Money = function(a,b,shopmoney)
    local input = lib.inputDialog('Withdraw Money', {
        {type = 'number', label = 'Amount of Money',  required = true, min = 1, max = shopmoney, icon = 'dollar-sign'},
        {type = 'checkbox', label = 'I confirm the withdraw.',  required = true},
    })


    if not input then
        Open_Shop_Safe(a,b)
    else
        MVS_C.TriggerServerCallback('maV-shops:Withdraw_Money', {a,b, input[1]}, function(dd)
            if dd then


                MVS.Notify(
                    "Success",
                    "Withdraw successful.",
                    "success"
                )
                Open_Shop_Safe(a,b)
            else
                Open_Shop_Safe(a,b)
            end
        end)
    end

end

Open_Put_Item = function(a,b)


    options = {}
        
    MVS_C.TriggerServerCallback('maV-shops:GetInventory', {}, function(inventory)
        if a ~= nil then
            for k,v in pairs(inventory) do
                count = 0
                if v.count ~= nil then count = v.count else count = v.amount end

                table.insert(options, {
                    title = v.label.. ' x'..count,
                    icon = 'plus',
                    onSelect = function()
                        Put_Item(a,b,v,count)
                    end,
                })
            end
            

            lib.registerContext({
                id = 'open_put_item',
                title = "Put Item",
                menu = 'open_shop',
                onBack = function()
                    Open_Shop(a,b)
                end,
                options = options
            })
            lib.showContext('open_put_item')
        end
    end)
end

Put_Item = function(a,b,c,d)
    local input = lib.inputDialog(c.label..' Put Item', {
        {type = 'number', label = 'Amount',  required = true, min = 1, max = d, icon = 'minus'},
    })


    if not input then
        MVS.Notify(
            "Error",
            "Put item operation canceled",
            "error"
        )
        Open_Put_Item(a,b)
    else
        MVS_C.TriggerServerCallback('maV-shops:PutItem', {a,b,c,input[1]}, function(dd)
            if dd then
                MVS.Notify(
                    "Success",
                    "The item was successfully put into storage",
                    "success"
                )
            end
            Open_Put_Item(a,b)
        end)
    end


end

Open_Shop_Stash = function(a,b)
    MVS_C.TriggerServerCallback('maV-shops:GetShopStash', {a,b}, function(dd)
        if dd ~= nil then
            options = {}
            for k,v in pairs(dd) do
                print(v.item_Name)
                table.insert(options, {
                    title = v.item_Label.. ' x'..v.item_Count,
                    icon = 'box',
                    onSelect = function()
                        Stash_Item(a,b,v)
                    end,
                })
            end

            lib.registerContext({
                id = 'open_shop_stash',
                title = "Shop Stash",
                menu = 'open_shop',
                onBack = function()
                    Open_Shop(a,b)
                end,
                options = options
            })
            lib.showContext('open_shop_stash')
        end
    
    end)
end


Stash_Item = function(a,b,v)

    options = {
        {
            title = 'Put The Item on Sale',
            icon = 'dollar-sign',
            onSelect = function()
                Stash_Item_Sell(a,b,v)
            end
        },
        {
            title = 'Take The Item to The Shop Stash',
            icon = 'hand-holding-heart',
            onSelect = function()
                Stash_Item_Get(a,b,v)
            end
        }
    }


    lib.registerContext({
        id = 'stash_item',
        title = v.item_Label.. ' x'..v.item_Count,
        menu = 'open_shop_stash',
        onBack = function()
            Open_Shop_Stash(a,b)
        end,
        options = options
    })
    lib.showContext('stash_item')
end

Stash_Item_Sell = function(a,b,v)
    local input = lib.inputDialog(v.item_Label..' Sell Item', {
        {type = 'number', label = 'Amount',  required = true, min = 1, max = v.item_Count, icon = 'plus'},
        {type = 'number', label = 'Price',  required = true, min = 1, icon = 'dollar-sign'},

    })

    if not input then
        MVS.Notify(
            "Error",
            "Sell item operation canceled",
            "error"
        )
        Open_Shop_Stash(a,b)
    else
        MVS_C.TriggerServerCallback('maV-shops:StashSellItem', {a,b,v,input[1],input[2]}, function(dd)
            if dd then
                MVS.Notify(
                    "Success",
                    "Sell item operation complated.",
                    "success"
                )
                Open_Shop_Stash(a,b)
            end
        end)
    end
end

Stash_Item_Get = function(a,b,v)
    local input = lib.inputDialog(v.item_Label..' Get Item', {
        {type = 'number', label = 'Amount',  required = true, min = 1, max = v.item_Count, icon = 'minus'},
    })

    if not input then
        MVS.Notify(
            "Error",
            "Get item operation canceled",
            "error"
        )
        Open_Shop_Stash(a,b)
    else
        MVS_C.TriggerServerCallback('maV-shops:StashItemGet', {a,b,v,input[1]}, function(dd)
            if dd then
                MVS.Notify(
                    "Success",
                    "Get item operation complated.",
                    "success"
                )
                Open_Shop_Stash(a,b)
            end
        end)
    end
end

Open_Products_Sale = function(a,b)
    options = {}
    
    MVS_C.TriggerServerCallback('maV-shops:ProductsSale', {a,b}, function(dd)
        for k,v in pairs(dd) do
            table.insert(options, {
                title = v.item_Label..' x'..v.item_Count..' $'..v.item_SellPrice,
                icon = 'chevron-right',
                onSelect = function()
                    ProductSaleItem(a,b,v)
                end
            })
        end
        lib.registerContext({
            id = 'open_products_sale',
            title = "Products on Sale",
            menu = 'open_shop',
            onBack = function()
                Open_Shop(a,b)
            end,
            options = options
        })
        lib.showContext('open_products_sale')
    end)

    
end

ProductSaleItem = function(a,b,v)
    options = {
        {
            title = 'Remove Product From Sale',
            icon = 'box',
            onSelect = function()
                Remove_Product_Sale(a,b,v)
            end
        },
        {
            title = 'Change the Price of The Product',
            icon = 'dollar-sign',
            onSelect = function()
                Change_Price(a,b,v)
            end
        }
    }

    lib.registerContext({
        id = 'product_sale_item',
        title = v.item_Label..' x'..v.item_Count..' $'..v.item_SellPrice,
        menu = 'open_products_sale',
        onBack = function()
            Open_Products_Sale(a,b)
        end,
        options = options
    })
    lib.showContext('product_sale_item')
end

Remove_Product_Sale = function(a,b,v)
    local input = lib.inputDialog(v.item_Label..' Remove Product Sale', {
        {type = 'number', label = 'Amount',  required = true, min = 1, max = v.item_Count, icon = 'minus'},
    })

    if not input then
        MVS.Notify(
            "Error",
            "Remove product sale operation canceled",
            "error"
        )
        ProductSaleItem(a,b,v)
    else
        MVS_C.TriggerServerCallback('maV_shops:RemoveProductItem', {a,b,v,input[1]}, function(dd)
            if dd then
                MVS.Notify(
                    "Success",
                    "Remove product sale operation complated.",
                    "success"
                )
                Open_Products_Sale(a,b)
            end
        end)

    end


end


Change_Price = function(a,b,v)
    local input = lib.inputDialog(v.item_Label..' Change Price', {
        {type = 'number', label = 'Amount',  required = true, min = 1, icon = 'dollar-sign'},
    })

    if not input then
        MVS.Notify(
            "Error",
            "Change Price operation canceled",
            "error"
        )
        ProductSaleItem(a,b,v)
    else
        MVS_C.TriggerServerCallback('maV-shops:ChangePrice', {a,b,v,input[1]}, function(dd)
            if dd then
                MVS.Notify(
                    "Success",
                    "Change Price operation complated",
                    "success"
                )
                Open_Products_Sale(a,b,v)
            end
        end)
    end
end


Open_Change_Shop_Name = function(a,b)
    local input = lib.inputDialog('Change Shop Name', {
        {type = 'input', label = 'Shop Name',  required = true, min = 4, max = 25, icon = 'hashtag'},
        {type = 'checkbox', label = 'I am sure I spelled my store name correctly.',  required = true},
    })

    if not input then
        MVS.Notify(
            "Error",
            "Change Shop Name operation canceled",
            "error"
        )
    else
        MVS_C.TriggerServerCallback('maV-shops:ChangeName', {a,b,input[1]}, function(dd)
            if dd then
                MVS.Notify(
                    "Success",
                    "Change Shop Name operation complated.",
                    "success"
                )
            end
        end)
    end

end

RegisterNetEvent('maV-shops:Notification', function(a)
    MVS.Notify(
        a[1],
        a[2],
        a[3]
    )
end)



function OpenShopCenter()
	ESX.UI.Menu.CloseAll()

  	local elements = {}

	  ESX.TriggerServerCallback('esx_kr_shop:getShopList', function(data)
		for i=1, #data, 1 do
			table.insert(elements, {label =  data[i]["ShopNumber"] .. ' Numaralı Marketi Satın Al [$' .. data[i]["ShopValue"] .. ']', value = 'kop', price = data[i]["ShopValue"], shop = data[i]["ShopNumber"]})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shopcenter', {
			title    = 'Mağazalar Zinciri',
			align    = 'left',
			elements = elements
		}, function(data, menu)
			if data.current.value == 'kop' then
				ESX.UI.Menu.CloseAll()
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'name', {
					title = "Marketenize Bir İsim Verin"
				}, function(data2, menu2)
					local name = data2.value
					TriggerServerEvent('esx_kr_shops:BuyShop', name, data.current.price, data.current.shop, data.current.bought)
					menu2.close()
				end, function(data2, menu2)
					menu2.close()
				end)
			end
		
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenBoss()
	ESX.TriggerServerCallback('esx_kr_shop:getOwnedShop', function(data)
		ESX.TriggerServerCallback('esx_kr_shop:BosgetOwnedShop', function(bosss)
			if bosss then
				local elements = {}
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss',{
					title    = 'Mağaza',
					align    = 'left',
					elements = {
						{label = 'Kasada: $' .. data["money"],    value = ''},
						{label = 'Kasiyer Level: ' .. data["level"],    value = ''},
						{label = 'Satışa ürün koy', value = 'putitem'},
						{label = 'Satıştan ürün kaldır',    value = 'takeitem'},
						{label = 'Kasaya para koy',    value = 'putmoney'},
						{label = 'Kasadan para al',    value = 'takemoney'},
						{label = 'Kasiyeri Değiştir',    value = 'kasiyer'},
						{label = 'Marketin adını değiştir: $' .. Config.ChangeNamePrice,    value = 'changename'},
						{label = 'Marketi Yakındaki Oyuncuya Devret',   value = 'devret'}
					}
				}, function(data, menu)
					if data.current.value == 'putitem' then
						PutItem(number)
					elseif data.current.value == 'takeitem' then
						TakeItem(number)
					elseif data.current.value == 'kasiyer' then
						Kasiyer(number)
					elseif data.current.value == 'takemoney' then
						ESX.UI.Menu.CloseAll()

						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'takeoutmoney', {
							title = 'Ne kadar almak istiyorsun?'
						}, function(data2, menu2)
							local amount = tonumber(data2.value)
							TriggerServerEvent('esx_kr_shops:takeOutMoney', amount, number)
							menu2.close()

						end,function(data2, menu2)
							menu2.close()
						end)

					elseif data.current.value == 'putmoney' then
						ESX.UI.Menu.CloseAll()

						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'putinmoney', {
							title = 'Ne kadar koymak istiyorsun?'
						}, function(data3, menu3)
							local amount = tonumber(data3.value)
							TriggerServerEvent('esx_kr_shops:addMoney', amount, number)
							menu3.close()

						end,function(data3, menu3)
							menu3.close()
						end)

					elseif data.current.value == 'devret' then
						ESX.UI.Menu.CloseAll()    
						local player, distance = ESX.Game.GetClosestPlayer()
						if distance ~= -1 and distance <= 3.0 then
							TriggerServerEvent("esx_kr_shops:devret", GetPlayerServerId(player), number)
						else
							ESX.Game.Notify('Yakında kimse yok!', 'error')
							return false
						end

					elseif data.current.value == 'changename' then
						ESX.UI.Menu.CloseAll()    

						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'changename', {
							title = 'Yeni mağaza adınız?'
						}, function(data5, menu5)
							TriggerServerEvent('esx_kr_shops:changeName', number, data5.value)
							menu5.close()
						end,function(data5, menu5)
							menu5.close()
						end)
								
			
					end
				end,function(data, menu)
					menu.close()
				end)
			end
		end, number)
    end, number)
end



function OpenShipmentDelivery(id)
	ESX.UI.Menu.CloseAll()
	local elements = {}
	for i=1, #MVS.Config.General_Setting.SatinAlmaliMarket.Items, 1 do
		ESX.TriggerServerCallback('esx:GetItems', function(data)
			local fiyat = MVS.Config.General_Setting.SatinAlmaliMarket.Items[i].price
			local weight = ESX.Math.Round(data.weight /1000, 1)
			local label = data.label
			table.insert(elements, {labels =  label, label =  label .. ' $' .. fiyat .. ' adeti / ' .. weight .. 'kg',	value = MVS.Config.General_Setting.SatinAlmaliMarket.Items[i].item, price = fiyat})
		end, MVS.Config.General_Setting.SatinAlmaliMarket.Items[i].item)
	end
	Citizen.Wait(2000)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shipitem',{
		title    = 'Mağaza',
		align    = 'left',
		elements = elements
	}, function(data, menu)
		menu.close()
		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'krille', {
			title = 'Kaç adet almak istiyorsun?'
		}, function(data2, menu2)
			menu2.close()
			TriggerServerEvent('esx_kr_shop:MakeShipment', data.current.value, data.current.price, tonumber(data2.value))

		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()
	end)
end

function TakeItem(number)
  	local elements = {}
  	ESX.TriggerServerCallback('esx_kr_shop:getShopItems', function(result)
		for i=1, #result, 1 do
			if result[i].count > 0 then
				table.insert(elements, {label = result[i].label .. ' | ' .. result[i].count ..' Adet Ürün [Tanesi ' .. result[i].price .. ' $]', value = 'removeitem', ItemName = result[i].item})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'takeitem',{
			title    = 'Mağaza',
			align    = 'left',
			elements = elements
		}, function(data, menu)
			local name = data.current.ItemName
			if data.current.value == 'removeitem' then
				menu.close()
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'howmuch', {
					title = 'Kaç tanesini kaldırmak istiyorsunuz?'
				}, function(data2, menu2)
					local count = tonumber(data2.value)
					menu2.close()
					TriggerServerEvent('esx_kr_shops:RemoveItemFromShop', number, count, name)
				end, function(data2, menu2)
					menu2.close()
				end)

			end
		end,function(data, menu)
			menu.close()
		end)
  	end, number)
end

function Kasiyer(number)
	local elements = {}
	for i=1, #Config.CalisanLevel, 1 do
	
		table.insert(elements, {
			label = Config.CalisanLevel[i].pedname .. ' | Level: ' .. i ..' | Fiyatı: '..Config.CalisanLevel[i].rentprice, 
			value = 'add', 
			ss = Config.CalisanLevel[i],
			id = i
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'takeitem',{
		title    = 'Kasiyer Satın Al',
		align    = 'left',
		elements = elements
	}, function(data, menu)
		local ss = data.current.ss
		local id = data.current.id
		if data.current.value == 'add' then
			menu.close()
			TriggerServerEvent('wiz-shop:KasiyerDegistir', ss, id, number)

		end
	end,function(data, menu)
		menu.close()
	end)
end

function PutItem(number)
	local elements = {}
	ESX.TriggerServerCallback('esx_kr_shop:getInventory', function(result)
		for x,y in pairs(result) do
			local invitem = y
			if invitem.count > 0 and not string.match(invitem.name, 'weapon_') and not invitem.unique then
				table.insert(elements, { label = invitem.label .. ' | ' .. invitem.count .. 'x', count = invitem.count, name = invitem.name })
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'putitem', {
			title    = 'Mağaza',
			align    = 'left',
			elements = elements
		}, function(data, menu)
			ESX.UI.Menu.CloseAll()
			local itemName = data.current.name
			local invcount = data.current.count
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'sell', {
				title = 'Kaç adet satmak istiyorsunuz?'
			}, function(data2, menu2)
				local count = tonumber(data2.value)
				if count > invcount then
					ESX.Game.Notify('Senden fazla olanı satamazsın')
					menu2.close()
					menu.close()
				else
					menu2.close()
					menu.close()

					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'sellprice', {
						title = 'Ürünü ne kadara satmak istiyorsunuz.'
					}, function(data3, menu3)
						menu3.close()
						local price = tonumber(data3.value)
						TriggerServerEvent('esx_kr_shops:setToSell', number, itemName, count, price)
					end,function(data3, menu3)
						menu3.close()
					end)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)

	end)
end

RegisterNetEvent('wiz:MarketSatinAL')
AddEventHandler('wiz:MarketSatinAL', function()
	local coords = GetEntityCoords(PlayerPedId())
	local distance = #(coords - vector3(MVS.Zones.Store_Purchasing.coords.x, MVS.Zones.Store_Purchasing.coords.y, MVS.Zones.Store_Purchasing.coords.z))
	if distance < 2 then

		OpenShopCenter()

	end


end)


RegisterNetEvent('wiz:MarketToptanci')
AddEventHandler('wiz:MarketToptanci', function()
	local coords = GetEntityCoords(PlayerPedId())
	local distance = #(coords - vector3(MVS.Zones.Wholesaler.coords.x, MVS.Zones.Wholesaler.coords.y, MVS.Zones.Wholesaler.coords.z))
	
	if distance < 2 then
		if marketId ~= 0 then
			OpenShipmentDelivery(marketId)
		else
			TriggerEvent('notification', "Senin marketin yok. Buradan malzeme alamazsın.", 2)
		end
	end
	
end)


RegisterNetEvent('wiz:MarketBak')
AddEventHandler('wiz:MarketBak', function()
	local coords = GetEntityCoords(PlayerPedId())
	for k,v in pairs(Config.Zones) do
		local distance = #(coords - vector3(v.Pos.x, v.Pos.y, v.Pos.z))
		-- if distance < 10.0 then
			time = 1
			-- DrawMarker(2, v.Pos.x, v.Pos.y, v.Pos.z + 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 180, 0, 200, false, true, 2, false, false, false, false)
			if distance < 3 then
				number = v.Pos.number
				if number == 'center' then
					if distance < 3 then

						OpenShopCenter()
				
					end
				else
					-- DrawText3D(v.Pos.x, v.Pos.y, v.Pos.z + 0.9, "[E] Market (No. "..v.Pos.number..")")
					-- if IsControlJustReleased(0, 38) then
						ESX.TriggerServerCallback("user",function(userCash, userBank)
						ESX.TriggerServerCallback('esx_kr_shop:BosgetOwnedShop', function(data)
							ESX.TriggerServerCallback('esx_kr_shop:getShopItems', function(result)
								if result then
									ESX.TriggerServerCallback('esx_kr_shop:getShopName', function(name)
									
										if name then
											
											

											category = {
												{name = "Hepsi", categoryname = "all"}
											}
											add = {}
											for k,v in pairs(result) do
												if Config.ItemsCategoryList[v.item] ~= nil then
													v.type = Config.ItemsCategoryList[v.item].type
													if add[Config.ItemsCategoryList[v.item].type] == nil then
														add[Config.ItemsCategoryList[v.item].type] = {}
														table.insert(category, {name = Config.ItemsCategoryList[v.item].type})
													end
												end
                                                 
											end

											
											SendNUIMessage({
                                                  type = "ui",
                                                  items = result,
                                                  category = category,
                                                  cash = userCash,
                                                  bank = userBank,
                                                  shop = name,
												  boss = data
                                             })
                                             SetDisplay(true, true)
										end
									end, number)
								end
							end, number)
						end, number)
                         end)
					-- end
				end
			end
		-- end
	end	


end)


RegisterNetEvent('esx_kr_shops:setBlip')
AddEventHandler('esx_kr_shops:setBlip', function()


	if blip then
		for i = 1, #displayedBlips do
			RemoveBlip(displayedBlips[i])
		end
		displayedBlips = {}
		blip = false
	else
		ESX.TriggerServerCallback('esx_kr_shop:getOwnedBlips', function(blips)


			if blips ~= nil then
				createBlip(blips)
			end
		end)
		blip = true
	end


  	
end)

RegisterNetEvent('esx_kr_shops:removeBlip')
AddEventHandler('esx_kr_shops:removeBlip', function()
	for i=1, #displayedBlips do
    	RemoveBlip(displayedBlips[i])
	end
end)

function createBlip(blips)
	for k,v in pairs(Config.Zones) do
		name = ""
		
		if blips[k]["ShopName"] == "" then
			name = "- Market No: ("..blips[k]["ShopNumber"]..")"
		else
			name = blips[k]["ShopName"]
		end
		
		local blip = AddBlipForCoord(vector3(v.Pos.x, v.Pos.y, v.Pos.z))
		SetBlipSprite (blip, 52)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.5)
		SetBlipColour (blip, 69)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(name)
		EndTextCommandSetBlipName(blip)
		table.insert(displayedBlips, blip)

		
				
	end
end

local blip = false
-- RegisterNetEvent("esx-kr-advanced-shops:blipAcKapa")
-- AddEventHandler("esx-kr-advanced-shops:blipAcKapa", function()
-- 	if blip then
-- 		TriggerEvent("esx_kr_shops:removeBlip")
-- 		blip = false
-- 	else
-- 		TriggerEvent("esx_kr_shops:setBlip")
-- 		blip = true
-- 	end
-- end)


function DrawText3D(x,y,z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	SetTextScale(0.30, 0.30)
	SetTextFont(0)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	SetDrawOrigin(x,y,z, 0)
	DrawText(0.0, 0.0)
	local factor = (string.len(text)) / 250
	DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
	ClearDrawOrigin()
end