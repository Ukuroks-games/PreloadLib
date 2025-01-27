local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local switch = require(ReplicatedStorage.Packages.switch)

local preloafdlib = {}

function GetPreloadFolder(): Folder
	local f = Workspace:FindFirstChild("preload")

	if not f then
		f = Instance.new("Folder", workspace)
	end

	return f
end

--[[
	Preload and keep it
]]
function _preload(PreloadFolder: Folder, Uri: string, type)
	local preload = PreloadFolder:FindFirstChild(Uri)

	if not preload then
		local new 
		
		local content = Content.fromUri(Uri)

		switch(type)
		{
			["Image"] = function()
				new = Instance.new("ImageLabel", PreloadFolder)
				new.ImageContent = content
			end,
			["Sound"] = function()
				new = Instance.new("Sound", PreloadFolder)
				new.Sound = Uri
			end
		}

		new.Name = Uri
	else
		warn("Already preloaded and keeping")
	end
end

function preloafdlib.preload(Uri: string, type)
	local PreloadFolder: Folder = GetPreloadFolder()
	
	_preload(PreloadFolder, Uri)

	ContentProvider:PreloadAsync(PreloadFolder:GetChildren())
end

function preloafdlib.preloadList(Uris: {string}, type)
	local PreloadFolder = GetPreloadFolder()
	
	for _, v in pairs(Uris) do
		_preload(PreloadFolder, v)
	end

	ContentProvider:PreloadAsync(PreloadFolder:GetChildren())
end

function preloafdlib.unkeep(Uri: string)
	local PreloadFolder = GetPreloadFolder()
	local preload = PreloadFolder:FindFirstChild(Uri)

	if preload then
		preload:Destroy()
	end
end

preloafdlib.__call = preloafdlib.preload

return preloafdlib
