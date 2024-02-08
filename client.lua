
local creatorIsOpen = false
local zoom = 'face'
local nuist = false


function ShowCharacterCreator(enabled)
    if enabled == true then
        creatorIsOpen = true
        SendNUIMessage({
            action = "toggle",
            status = true
        })
        SetNuiFocus(true, true)
        SetEntityCoords(PlayerPedId(), -1466.478, -536.5296, 50.7325, 0)
    else
        creatorIsOpen = false
        SendNUIMessage({
            action = "toggle",
            status = false
        })
        SetNuiFocus(false, false)
    end
end

function renderCamera()
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    if(not DoesCamExist(cam)) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        SetCamCoord(cam, GetEntityCoords(GetPlayerPed(-1)))
        SetCamRot(cam, 0.0, 0.0, 0.0)
        SetCamActive(cam,  true)
        RenderScriptCams(true,  false,  0,  true,  true)
        SetCamCoord(cam, GetEntityCoords(GetPlayerPed(-1)))
    end

    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
    ClearPedTasksImmediately(GetPlayerPed(-1))
    
    if zoom == "face" then
        SetCamCoord(cam, x+0.3, y+0.21, z+0.7)
        SetCamRot(cam, 0.0, 0.0, 125.0)
    elseif zoom == "torso" then
        SetCamCoord(cam, x+0.8, y+0.58, z+0.3)
        SetCamRot(cam, 0.0, 0.0, 125.0)
    elseif zoom == "legs" then
        SetCamCoord(cam, x+0.8, y+0.58, z-0.5)
        SetCamRot(cam, 0.0, 0.0, 125.0)
    end
end

local rotatePed = 124.0

Citizen.CreateThread(function()
	while true do
		if creatorIsOpen == true then
			renderCamera()
			SetEntityHeading(GetPlayerPed(-1), rotatePed)
		end
		Citizen.Wait(0)
	end
end)

RegisterNUICallback("changeskin", function(data)
    local value = tonumber(data.value)
    local name = data.name

    TriggerEvent('skinchanger:getSkin', function(skin)
        skin[name] = value
        TriggerEvent('skinchanger:loadSkin', skin)
    end)
end)

RegisterNUICallback("changezoom", function(data)  
    zoom = data.zoom
end)

RegisterNUICallback("rotateped", function(data)
    if data.side == 'left' then
        rotatePed = rotatePed - 2.0
    elseif data.side == 'right' then
        rotatePed = rotatePed + 2.0
    end
end)

RegisterNUICallback("createcharacter", function()
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('esx_skin:save', skin)
    end)

    DoScreenFadeOut(1000)

    Citizen.Wait(1000)
    
    ShowCharacterCreator(false)
    SetEntityCoords(PlayerPedId(), -829.99682617188, -126.06985473633, 28.175411224365, 0)
    SetEntityHeading(PlayerPedId(), 128.0)

    Citizen.Wait(1000)

    DoScreenFadeIn(1000)
end)


-----------------------------------------------------