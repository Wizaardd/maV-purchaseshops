MVS = {}

MVS.ChangeNamePrice = 10000

MVS.Shops_Buy_Money = "bank" -- cash
MVS.Wholesaler_Buy_Money = "bank" -- cash

MVS.Shops_Change_Name_Money = {
    "bank", 2000
}


MVS.Notify = function(a,b,c)
    lib.notify({
        title = a,
        description = b,
        type = c
    })
end


MVS.Wholesaler_Item = {
    {
        item_Name = "phone",
        item_Label = "Phone",
        item_Price = 5,
    },
    {
        item_Name = "sandwich",
        item_Label = "Sandwich",
        item_Price = 5,
    },
    {
        item_Name = "tosti",
        item_Label = "Tost",
        item_Price = 11,
    },
    {
        item_Name = "water_bottle",
        item_Label = "Bottle of Water",
        item_Price = 2,
    },
    {
        item_Name = "coffee",
        item_Label = "Coffee",
        item_Price = 3,
    },
}
  

MVS.Zones = {
    Shops = {
        [1] = {
            Pos = {x = 373.875,   y = 325.896,  z = 102.566, number = 1},
            PedPos = {x = 372.403, y = 326.277, z = 103.566, h = 253.439},
            Ped = "a_m_m_farmer_01",
            Icon = 'store',
            Blip = {
                Sprite = 52,
                Scale = 0.5,
                Colour = 69,
            },
            Price = 4000,
        
        },
        [2] = {
            Pos = {x = 2557.458,  y = 382.282,  z = 107.622, number = 2},
            PedPos = {x = 2557.43, y = 380.538, z = 108.623, h = 3.51666},
            Ped = "a_m_m_farmer_01",
            Icon = 'store',
            Blip = {
                Sprite = 52,
                Scale = 0.5,
                Colour = 69,
            },
            Price = 4000,
        
        },
        [3] = {
            Pos = {x = -3038.939, y = 585.954,  z = 6.908, number = 3},
            PedPos = {x = -3038.8, y = 584.621, z = 7.90893, h = 19.4789},
            Ped = "a_m_m_farmer_01",
            Icon = 'store',
            Blip = {
                Sprite = 52,
                Scale = 0.5,
                Colour = 69,
            },
            Price = 4000,
        },
        [4] = {
            Pos = {x = -1487.553, y = -379.107,  z = 39.163, number = 4},
            PedPos = {x = -1486.4, y = -377.77, z = 40.1633, h = 138.571},
            Ped = "a_m_m_farmer_01",
            Icon = 'store',
            Blip = {
                Sprite = 52,
                Scale = 0.5,
                Colour = 69,
            },
            Price = 4000,
        },
        [5] = {
            Pos = {x = 1392.562,  y = 3604.684,  z = 33.980, number = 5},
            PedPos = {x = 1392.43, y = 3606.23, z = 34.9808, h = 195.987},
            Ped = "a_m_m_farmer_01",
            Icon = 'store',
            Blip = {
                Sprite = 52,
                Scale = 0.5,
                Colour = 69,
            },
            Price = 4000,
        },
        [6] = {
            Pos = {x = -2968.243, y = 390.910,   z = 14.043, number = 6},
            PedPos = {x = -2966.4, y = 390.855, z = 15.0433, h = 82.2110},
            Ped = "a_m_m_farmer_01",
            Icon = 'store',
            Blip = {
                Sprite = 52,
                Scale = 0.5,
                Colour = 69,
            },
            Price = 4000,
        },
        [7] = {
            Pos = {x = 2678.916,  y = 3280.671, z = 54.241, number = 7},
            PedPos = {x = 2678.07, y = 3279.32, z = 55.2411, h = 327.604},
            Ped = "a_m_m_farmer_01",
            Icon = 'store',
            Blip = {
                Sprite = 52,
                Scale = 0.5,
                Colour = 69,
            },
            Price = 4000,
        },
        [8] = {
            Pos = {x = -48.519,   y = -1757.514, z = 28.421, number = 8},
            PedPos = {x = -46.845, y = -1757.9, z = 29.4209, h = 41.2686},
            Ped = "a_m_m_farmer_01",
            Icon = 'store',
            Blip = {
                Sprite = 52,
                Scale = 0.5,
                Colour = 69,
            },
            Price = 4000,
        },
        [9] = {
            Pos = {x = 1163.373,  y = -323.801,  z = 68.205, number = 9},  
            PedPos = {x = 1164.73, y = -322.69, z = 69.2050, h = 88.5084},
            Ped = "a_m_m_farmer_01",
            Icon = 'store',
            Blip = {
                Sprite = 52,
                Scale = 0.5,
                Colour = 69,
            },
            Price = 333,
    
        },

        
        [10] = {
            Pos = {x = -707.501,  y = -914.260,  z = 18.215, number = 10},
            PedPos = {x = -706.07, y = -913.54, z = 19.2155, h = 87.1191},
            Ped = "a_m_m_farmer_01",
            Icon = 'store',
            Blip = {
                Sprite = 52,
                Scale = 0.5,
                Colour = 69,
            },
            Price = 4000,
        },
        [11] = { 
            Pos = {x = -1820.523, y = 792.518,   z = 137.118, number = 11},  
            PedPos = {x = -1820.0, y = 794.185, z = 138.088, h = 128.521},
            Ped = "a_m_m_farmer_01",
            Icon = 'store',
            Blip = {
                Sprite = 52,
                Scale = 0.5,
                Colour = 69,
            },
            Price = 4000,
        },
        [12] = {
            Pos = {x = 1698.388,  y = 4924.404,  z = 41.063, number = 12},
            PedPos = {x = 1697.69, y = 4923.22, z = 42.0636, h = 322.754},
            Ped = "a_m_m_farmer_01",
            Icon = 'store',
            Blip = {
                Sprite = 52,
                Scale = 0.5,
                Colour = 69,
            },
            Price = 55,
        },
        [13] = {
            Pos = {x = 1961.464,  y = 3740.672, z = 31.343, number = 13},
            PedPos = {x = 1960.05, y = 3739.94, z = 32.3437, h = 288.756},
            Ped = "a_m_m_farmer_01",
            Icon = 'store',
            Blip = {
                Sprite = 52,
                Scale = 0.5,
                Colour = 69,
            },
            Price = 66,
        },
        [14] = {
           Pos = {x = 1135.808,  y = -982.281,  z = 45.415, number = 14},
           PedPos = {x = 1134.19, y = -982.35, z = 46.4158, h = 276.812},
           Ped = "a_m_m_farmer_01",
           Icon = 'store',
           Blip = {
            Sprite = 52,
            Scale = 0.5,
            Colour = 69,
           },
           Price = 4000,
        },
        [15] = {
            Pos = {x =  25.88,     y = -1347.1,   z = 28.5, number = 15},
            PedPos = {x = 24.4382, y = -1347.5, z = 29.4970, h = 253.938},
            Ped = "a_m_m_farmer_01",
            Icon = 'store',
            Blip = {
                Sprite = 52,
                Scale = 0.5,
                Colour = 69,
            },
            Price = 4000,
        },
        [16] = {
            Pos = {x = 547.431,   y = 2671.710, z = 41.156, number = 16},
            PedPos = {x = 549.018, y = 2671.61, z = 42.1564, h = 96.4279},
            Ped = "a_m_m_farmer_01",
            Icon = 'store',
            Blip = {
                Sprite = 52,
                Scale = 0.5,
                Colour = 69,
            },
            Price = 4000,
        },
        [17] = {
            Pos = {x = -3241.927, y = 1001.462, z = 11.830, number = 17},
            PedPos = {x = 549.018, y = 2671.61, z = 42.1564, h = 96.4279},
            Ped = "a_m_m_farmer_01",
            Icon = 'store',
            Blip = {
                Sprite = 52,
                Scale = 0.5,
                Colour = 69,
            },
            Price = 4000,
        },
        [18] = {
            Pos = {x = 1166.024,  y = 2708.930,  z = 37.157, number = 18},
            PedPos = {x = 1165.59, y = 2710.77, z = 38.1577, h = 177.594},
            Ped = "a_m_m_farmer_01",
            Icon = 'store',
            Blip = {
                Sprite = 52,
                Scale = 0.5,
                Colour = 69,
            },
            Price = 4000,
        },
        [19] = {
            Pos = {x = 1729.216,  y = 6414.131, z = 34.037, number = 19} ,
            PedPos = {x = 1727.74, y = 6415.15, z = 35.0372, h = 232.696},
            Ped = "a_m_m_farmer_01",
            Icon = 'store',
            Blip = {
                Sprite = 52,
                Scale = 0.5,
                Colour = 69,
            },
            Price = 4000,
        },
    },
    Wholesaler = {
        coords = {x = 1244.25, y = -3248.5, z = 6.02876, h = 275.208},
        ped = 0x26C3D079,
        blip = {
            sprite = 52,
            scale = 0.5,
            colour = 3,
            name = "Wholesaler"
        }
    },
    Store_Purchasing = {
        coords = {x = 62.7971, y = -1728.0, z = 29.5933, h = 46.7021},
        ped = 0x040EABE3,
        blip = {
            sprite = 153,
            scale = 0.7,
            colour = 5,
            name = "Store Purchasing"
        }
    }
   
}

