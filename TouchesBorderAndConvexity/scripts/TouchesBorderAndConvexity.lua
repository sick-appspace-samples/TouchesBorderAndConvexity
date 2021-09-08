
--Start of Global Scope---------------------------------------------------------

print('AppEngine Version: ' .. Engine.getVersion())

-- Delay in ms between visualization steps for demonstration purpose
local DELAY = 1000

-- Create viewer
local viewer = View.create('viewer2D1')

-- Setup graphical overlay
local decoration = View.PixelRegionDecoration.create()
decoration:setColor(230, 0, 0) -- Red

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------

local function main()
  viewer:clear()
  local img = Image.load('resources/TouchesBorderAndConvexity.bmp')
  viewer:addImage(img)
  viewer:present()
  Script.sleep(DELAY) -- for demonstration purpose only

  -- Finding blobs
  viewer:clear()
  local holeRegion = img:threshold(150, 255)
  viewer:addImage(holeRegion:toImage(img))
  viewer:present()
  Script.sleep(DELAY) -- for demonstration purpose only
  local holes = holeRegion:findConnected(100)

  -- Filtering blobs to match those which are concave and not touching the image border.
  local holeFilterNOK = Image.PixelRegion.Filter.create()
  holeFilterNOK:setCondition('TOUCHESBORDER', false)
  holeFilterNOK:setRange('CONVEXITY', 0, 0.9)
  local holesNOK = holeFilterNOK:apply(holes, img)

  -- Plot a red marker in each NOK hole
  local imageID = viewer:addImage(img)
  for _, hole in ipairs(holesNOK) do
    viewer:addPixelRegion(hole, decoration, nil, imageID)
  end
  viewer:present()
  print('App finished.')
end

Script.register('Engine.OnStarted', main)

--End of Function and Event Scope--------------------------------------------------
