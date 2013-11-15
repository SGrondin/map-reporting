embeddedJS = require "./embeddedJS";
mapUtils = require "./mapUtils"
SVG = (require "./SVG").SVG
Node = (require "./Node").Node
Shape = (require "./Shape").Shape

shapeFromZone = (zone, config) ->
	shape = new Shape zone.ID, zone.link, zone.name, zone.value
	zone.coordinates.split(";").forEach (vector) ->
		shape.addVector vector, config.background.x, config.background.y
	shape

# Config must be an object, Shapes is an array of strings
exports.generateMap = (config, zones, image) ->
	svg = new SVG()
	svg.setAttributes {width:config.width, height:config.height}
	svg.setEmbeddedJS embeddedJS.getEmbeddedJS(config.labels)

	# Bitmap background
	if image?
		bg = new Node svg, "image"
		bg.setAttributes {"xlink:href":"data:image/png;base64,"+image,\
			x:config.background.x, y:config.background.y, height:config.background.height, width:config.background.width,\
			filter:"url(#fdesaturation)"}

	# Adds shapes to SVG
	for zone in zones
		(shapeFromZone zone, config).addToSVG svg, config.scale.initial, config.scale.alternate, config.threshold, config.IDs

	# Fill pattern
	pattern = new Node null, "pattern"
	pattern.setAttributes {width:"10", height:"10", patternUnits:"userSpaceOnUse"}
	innerPattern = new Node pattern, "path"
	innerPattern.setAttributes {d:"M 0 10 L 10 0 Z", stroke:"#FFFFFF", "stroke-opacity":0.75, "stroke-width":2}
	svg.addDef pattern, "dashed"

	# Desaturation filter
	desaturation = new Node null, "filter"
	desaturation.setAttributes {x:0, y:0}
	desaturationFilter = new Node desaturation, "feColorMatrix"
	desaturationFilter.setAttributes {in:"SourceGraphic", type:"saturate", values:config.background.saturation}
	svg.addDef desaturation, "desaturation"

	# Scale
	halfUp = Math.floor(config.scale.width/2)
	halfDown = Math.ceil(config.scale.width/2)
	for i in [0..halfUp]
		value = i/(config.scale.width/2/100)
		line = new Node svg, "path"
		line.setAttributes {d:"M "+(config.scale.x+i)+" "+(config.scale.y+config.scale.height)+
			" L "+(config.scale.x+i)+" "+config.scale.y+" Z", stroke:mapUtils.getColor(value, "red", true),
			class:"bad", onmousedown:"changeScaleColor(evt);"}
	for i in [halfDown..config.scale.width]
		value = (i-halfDown)/(config.scale.width/2/100)
		line = new Node svg, "path"
		d = "M "+(config.scale.x+i)+" "+(config.scale.y+config.scale.height)+
			" L "+(config.scale.x+i)+" "+config.scale.y+" Z"
		initialColor = mapUtils.getColor(value, config.scale.initial, false)
		alternateColor = mapUtils.getColor(value, config.scale.alternate, false)
		line.setAttributes {d, stroke:initialColor, initialColor, alternateColor,\
			class:"good", onmousedown:"changeScaleColor(evt);"}

	# Dashboard elements
	textrectangle = new Node svg, "rect"
	textrectangle.setAttributes {x:config.dashboard.x, y:config.dashboard.y, width:config.dashboard.width,\
		height:config.dashboard.height, fill:"#FFFFFF", "fill-opacity":"0.7"}

	dashboardTitle = new Node svg, "text", "Nothing selected"
	dashboardTitle.setAttributes {x:config.dashboard.x+10, y:config.dashboard.y+16,\
		id:"dashboardTitle", "font-family":"Arial"}

	dashboardLink = new Node svg, "a"
	dashboardLink.setAttributes {"xlink:href":"", id:"dashboardLink", target:"_blank"}

	dashboardSatisfaction = new Node svg, "text", " "
	dashboardSatisfaction.setAttributes {x:config.dashboard.x+10, y:config.dashboard.y+41,\
		id:"dashboardSatisfaction", "font-family":"Arial"}

	# Innertext can't be empty because the embedded JS needs to be able to change the text
	dashboardLinkText = new Node dashboardLink, "text", " "
	dashboardLinkText.setAttributes {x:config.dashboard.x+10, y:config.dashboard.y+66,\
		id:"dashboardLinkText", "font-family":"Arial", "style":"text-decoration:underline;"}

	svg.toString()
