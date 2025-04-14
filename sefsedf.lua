local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local SwissUI = {}
SwissUI.__index = SwissUI

-- Colors and styling
local COLORS = {
    Background = Color3.fromRGB(30, 30, 40),
    Header = Color3.fromRGB(45, 45, 60),
    Section = Color3.fromRGB(40, 40, 50),
    Accent = Color3.fromRGB(0, 150, 200),
    Text = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(180, 180, 180)
}

local FONTS = {
    Header = Enum.Font.GothamBold,
    Body = Enum.Font.Gotham
}

-- Create a new SwissUI instance
function SwissUI.new(title)
    local self = setmetatable({}, SwissUI)
    
    -- Main frame
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "SwissUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 350, 0, 500)
    self.MainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.BackgroundColor3 = COLORS.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui
    
    -- Header
    self.Header = Instance.new("Frame")
    self.Header.Name = "Header"
    self.Header.Size = UDim2.new(1, 0, 0, 40)
    self.Header.BackgroundColor3 = COLORS.Header
    self.Header.BorderSizePixel = 0
    self.Header.Parent = self.MainFrame
    
    local headerText = Instance.new("TextLabel")
    headerText.Name = "Title"
    headerText.Size = UDim2.new(1, -20, 1, 0)
    headerText.Position = UDim2.new(0, 10, 0, 0)
    headerText.BackgroundTransparency = 1
    headerText.Text = title or "Swiss UI Library"
    headerText.TextColor3 = COLORS.Text
    headerText.Font = FONTS.Header
    headerText.TextSize = 18
    headerText.TextXAlignment = Enum.TextXAlignment.Left
    headerText.Parent = self.Header
    
    -- Container for sections
    self.SectionsContainer = Instance.new("ScrollingFrame")
    self.SectionsContainer.Name = "SectionsContainer"
    self.SectionsContainer.Size = UDim2.new(1, 0, 1, -40)
    self.SectionsContainer.Position = UDim2.new(0, 0, 0, 40)
    self.SectionsContainer.BackgroundTransparency = 1
    self.SectionsContainer.ScrollBarThickness = 5
    self.SectionsContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.SectionsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.SectionsContainer.Parent = self.MainFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = self.SectionsContainer
    
    self.Sections = {}
    
    return self
end

-- Add a new section to the UI
function SwissUI:AddSection(title, description)
    local section = {}
    
    -- Section frame
    section.Frame = Instance.new("Frame")
    section.Frame.Name = "Section_" .. title
    section.Frame.Size = UDim2.new(1, -20, 0, 0)
    section.Frame.Position = UDim2.new(0, 10, 0, 0)
    section.Frame.BackgroundColor3 = COLORS.Section
    section.Frame.BorderSizePixel = 0
    section.Frame.AutomaticSize = Enum.AutomaticSize.Y
    section.Frame.Parent = self.SectionsContainer
    
    local sectionLayout = Instance.new("UIListLayout")
    sectionLayout.Padding = UDim.new(0, 5)
    sectionLayout.Parent = section.Frame
    
    -- Section header
    section.Header = Instance.new("TextLabel")
    section.Header.Name = "Header"
    section.Header.Size = UDim2.new(1, 0, 0, 30)
    section.Header.BackgroundTransparency = 1
    section.Header.Text = "# " .. title
    section.Header.TextColor3 = COLORS.Accent
    section.Header.Font = FONTS.Header
    section.Header.TextSize = 16
    section.Header.TextXAlignment = Enum.TextXAlignment.Left
    section.Header.Parent = section.Frame
    
    -- Section description
    if description then
        section.Description = Instance.new("TextLabel")
        section.Description.Name = "Description"
        section.Description.Size = UDim2.new(1, -10, 0, 0)
        section.Description.Position = UDim2.new(0, 10, 0, 0)
        section.Description.BackgroundTransparency = 1
        section.Description.Text = description
        section.Description.TextColor3 = COLORS.SubText
        section.Description.Font = FONTS.Body
        section.Description.TextSize = 14
        section.Description.TextWrapped = true
        section.Description.TextXAlignment = Enum.TextXAlignment.Left
        section.Description.AutomaticSize = Enum.AutomaticSize.Y
        section.Description.Parent = section.Frame
    end
    
    -- Divider line
    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.Size = UDim2.new(1, 0, 0, 1)
    divider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    divider.BorderSizePixel = 0
    divider.Parent = section.Frame
    
    -- Options container
    section.OptionsContainer = Instance.new("Frame")
    section.OptionsContainer.Name = "Options"
    section.OptionsContainer.Size = UDim2.new(1, 0, 0, 0)
    section.OptionsContainer.BackgroundTransparency = 1
    section.OptionsContainer.AutomaticSize = Enum.AutomaticSize.Y
    section.OptionsContainer.Parent = section.Frame
    
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.Padding = UDim.new(0, 5)
    optionsLayout.Parent = section.OptionsContainer
    
    self.Sections[title] = section
    return section
end

-- Add a toggle option to a section
function SwissUI.AddToggle(section, optionName, defaultValue, callback)
    local toggle = {}
    defaultValue = defaultValue or false
    
    -- Toggle container
    toggle.Frame = Instance.new("Frame")
    toggle.Frame.Name = "Toggle_" .. optionName
    toggle.Frame.Size = UDim2.new(1, 0, 0, 25)
    toggle.Frame.BackgroundTransparency = 1
    toggle.Frame.Parent = section.OptionsContainer
    
    -- Toggle label
    toggle.Label = Instance.new("TextLabel")
    toggle.Label.Name = "Label"
    toggle.Label.Size = UDim2.new(0.7, 0, 1, 0)
    toggle.Label.BackgroundTransparency = 1
    toggle.Label.Text = "• " .. optionName
    toggle.Label.TextColor3 = COLORS.Text
    toggle.Label.Font = FONTS.Body
    toggle.Label.TextSize = 14
    toggle.Label.TextXAlignment = Enum.TextXAlignment.Left
    toggle.Label.Parent = toggle.Frame
    
    -- Toggle button
    toggle.Button = Instance.new("TextButton")
    toggle.Button.Name = "Button"
    toggle.Button.Size = UDim2.new(0.3, 0, 0.8, 0)
    toggle.Button.Position = UDim2.new(0.7, 0, 0.1, 0)
    toggle.Button.BackgroundColor3 = defaultValue and COLORS.Accent or Color3.fromRGB(80, 80, 80)
    toggle.Button.BorderSizePixel = 0
    toggle.Button.Text = defaultValue and "ON" or "OFF"
    toggle.Button.TextColor3 = COLORS.Text
    toggle.Button.Font = FONTS.Body
    toggle.Button.TextSize = 14
    toggle.Button.Parent = toggle.Frame
    
    -- Toggle functionality
    toggle.Value = defaultValue
    
    toggle.Button.MouseButton1Click:Connect(function()
        toggle.Value = not toggle.Value
        toggle.Button.BackgroundColor3 = toggle.Value and COLORS.Accent or Color3.fromRGB(80, 80, 80)
        toggle.Button.Text = toggle.Value and "ON" or "OFF"
        
        if callback then
            callback(toggle.Value)
        end
    end)
    
    return toggle
end

-- Add a dropdown option to a section
function SwissUI.AddDropdown(section, optionName, options, defaultOption, callback)
    local dropdown = {}
    options = options or {}
    defaultOption = defaultOption or (options[1] or "")
    
    -- Dropdown container
    dropdown.Frame = Instance.new("Frame")
    dropdown.Frame.Name = "Dropdown_" .. optionName
    dropdown.Frame.Size = UDim2.new(1, 0, 0, 0)
    dropdown.Frame.BackgroundTransparency = 1
    dropdown.Frame.AutomaticSize = Enum.AutomaticSize.Y
    dropdown.Frame.Parent = section.OptionsContainer
    
    local dropdownLayout = Instance.new("UIListLayout")
    dropdownLayout.Parent = dropdown.Frame
    
    -- Dropdown label
    dropdown.Label = Instance.new("TextLabel")
    dropdown.Label.Name = "Label"
    dropdown.Label.Size = UDim2.new(1, 0, 0, 25)
    dropdown.Label.BackgroundTransparency = 1
    dropdown.Label.Text = "• " .. optionName
    dropdown.Label.TextColor3 = COLORS.Text
    dropdown.Label.Font = FONTS.Body
    dropdown.Label.TextSize = 14
    dropdown.Label.TextXAlignment = Enum.TextXAlignment.Left
    dropdown.Label.Parent = dropdown.Frame
    
    -- Dropdown button (main)
    dropdown.MainButton = Instance.new("TextButton")
    dropdown.MainButton.Name = "MainButton"
    dropdown.MainButton.Size = UDim2.new(1, 0, 0, 25)
    dropdown.MainButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    dropdown.MainButton.BorderSizePixel = 0
    dropdown.MainButton.Text = defaultOption
    dropdown.MainButton.TextColor3 = COLORS.Text
    dropdown.MainButton.Font = FONTS.Body
    dropdown.MainButton.TextSize = 14
    dropdown.MainButton.Parent = dropdown.Frame
    
    -- Dropdown options frame
    dropdown.OptionsFrame = Instance.new("Frame")
    dropdown.OptionsFrame.Name = "Options"
    dropdown.OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
    dropdown.OptionsFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    dropdown.OptionsFrame.Visible = false
    dropdown.OptionsFrame.AutomaticSize = Enum.AutomaticSize.Y
    dropdown.OptionsFrame.Parent = dropdown.Frame
    
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.Parent = dropdown.OptionsFrame
    
    -- Create option buttons
    dropdown.OptionButtons = {}
    
    for _, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = "Option_" .. option
        optionButton.Size = UDim2.new(1, 0, 0, 25)
        optionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        optionButton.BorderSizePixel = 0
        optionButton.Text = option
        optionButton.TextColor3 = COLORS.Text
        optionButton.Font = FONTS.Body
        optionButton.TextSize = 14
        optionButton.Parent = dropdown.OptionsFrame
        
        optionButton.MouseButton1Click:Connect(function()
            dropdown.MainButton.Text = option
            dropdown.OptionsFrame.Visible = false
            if callback then
                callback(option)
            end
        end)
        
        table.insert(dropdown.OptionButtons, optionButton)
    end
    
    -- Toggle dropdown visibility
    dropdown.MainButton.MouseButton1Click:Connect(function()
        dropdown.OptionsFrame.Visible = not dropdown.OptionsFrame.Visible
    end)
    
    return dropdown
end

-- Add a button to a section
function SwissUI.AddButton(section, buttonName, callback)
    local button = {}
    
    -- Button frame
    button.Frame = Instance.new("TextButton")
    button.Frame.Name = "Button_" .. buttonName
    button.Frame.Size = UDim2.new(1, 0, 0, 30)
    button.Frame.BackgroundColor3 = COLORS.Accent
    button.Frame.BorderSizePixel = 0
    button.Frame.Text = buttonName
    button.Frame.TextColor3 = COLORS.Text
    button.Frame.Font = FONTS.Body
    button.Frame.TextSize = 14
    button.Frame.Parent = section.OptionsContainer
    
    button.Frame.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    return button
end

-- Toggle UI visibility
function SwissUI:Toggle()
    self.ScreenGui.Enabled = not self.ScreenGui.Enabled
end

-- Destroy the UI
function SwissUI:Destroy()
    self.ScreenGui:Destroy()
end

return SwissUI


