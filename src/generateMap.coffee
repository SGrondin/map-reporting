embeddedJS = require "./embeddedJS"
mapUtils = require "./mapUtils"
SVG = (require "./SVG").SVG
Node = (require "./Node").Node
Shape = (require "./Shape").Shape
defaultCSS = (require "./embeddedCSS").defaultCSS

shapeFromZone = (zone, config) ->
	# TODO: Maybe validate zone.ID, it needs to be alphanumeric?
	# TODO: Maybe validate zone.coordinates with regex?
	if ";" in zone.coordinates
		shape = new Shape zone.ID, zone.link, zone.name, zone.value
		zone.coordinates.split(";;;").forEach (s) ->
			s.split(";").forEach (vector) ->
				shape.addVector vector, config.background.x, config.background.y
			shape.resetNextInstruction() # Move the pencil over to the next part of the zone
	else
		shape = new Shape zone.ID, zone.link, zone.name, zone.value, zone.coordinates
	shape

# Config must be an object, Shapes is an array of strings
exports.generateMap = (config, zones) ->
	svg = new SVG(config, zones)
	# Sets the CDATA of the <script> tag. Ignored on the client side (in Node.toDOM).
	svg.setEmbeddedJS embeddedJS.getEmbeddedJS config.labels

	### Bitmap background ###
	if config.background.url?.length > 0 or config.background.base64?.length > 0
		bg = new Node svg, "image"
		image = if config.background.base64?.length > 0
			"data:image/png;base64,"+config.background.base64
		else
			config.background.url
		bg.setAttributes {"xlink:href":image,\
			x:config.background.x, y:config.background.y, height:config.background.height, width:config.background.width,\
			filter:"url(#fdesaturation)"}
	else
		bg = new Node svg, "rect"
		bg.setAttributes {"id":"defaultBackground", x:0, y:0, width:config.background.width, height:config.background.height}

	### Adds shapes to SVG ###
	for zone in zones
		(shapeFromZone zone, config).addToSVG svg, config

	### Fill pattern ###
	pattern = new Node null, "pattern"
	pattern.setAttributes {width:"10", height:"10", patternUnits:"userSpaceOnUse"}
	innerPattern = new Node pattern, "path"
	innerPattern.setAttributes {class:"nodatapattern", d:"M 0 10 L 10 0 Z"}
	svg.addDef pattern, "dashed"

	### Desaturation filter ###
	desaturation = new Node null, "filter"
	desaturation.setAttributes {x:0, y:0}
	desaturationFilter = new Node desaturation, "feColorMatrix"
	desaturationFilter.setAttributes {in:"SourceGraphic", type:"saturate", values:config.background.saturation}
	svg.addDef desaturation, "desaturation"

	### Scale ###
	scale = new Node svg, "g"
	scale.setAttributes {onmousedown:"mapReporting.changeScaleColor(evt);"}
	halfUp = Math.floor(config.scale.width*(~~config.threshold)/100)
	halfDown = halfUp+1
	# Remember that inlined SVGs on Firefox needs all attributes in lowercase
	for i in [0..halfUp]
		value = i/(halfUp/100)
		line = new Node scale, "path"
		line.setAttributes {d:"M "+(config.scale.x+i)+" "+(config.scale.y+config.scale.height)+" L "+
			(config.scale.x+i)+" "+config.scale.y+" Z", stroke:mapUtils.getColor(value, "red", true), class:"bad"}
	for i in [halfDown..config.scale.width]
		value = (i-halfDown)/((config.scale.width-halfUp)/100)
		line = new Node scale, "path"
		d = "M "+(config.scale.x+i)+" "+(config.scale.y+config.scale.height)+
			" L "+(config.scale.x+i)+" "+config.scale.y+" Z"
		initialColor = mapUtils.getColor(value, config.scale.initial, false)
		alternateColor = mapUtils.getColor(value, config.scale.alternate, false)
		line.setAttributes {d, stroke:initialColor, initialcolor:initialColor, alternatecolor:alternateColor, class:"good"}
	if config.scale.showNumbers
		scaleNumbers = new Node svg, "g"
		n1 = new Node scaleNumbers, "text", "0"
		n1.setAttributes {x:config.scale.x, y:(config.scale.y+config.scale.height+14), class:"scaleNumbers"}
		n2 = new Node scaleNumbers, "text", config.threshold+""
		n2.setAttributes {x:(config.scale.x+halfDown), y:(config.scale.y+config.scale.height+14),\
			class:"scaleNumbers"}
		n3 = new Node scaleNumbers, "text", "100"
		n3.setAttributes {x:(config.scale.x+config.scale.width), y:(config.scale.y+config.scale.height+14),\
			class:"scaleNumbers"}

	### Dashboard elements ###
	rectangle = new Node svg, "rect"
	rectangle.setAttributes {x:config.dashboard.x, y:config.dashboard.y, width:config.dashboard.width,\
		height:config.dashboard.height, id:"dashboardRectangle"}

	dashboardTitle = new Node svg, "text", config.labels.defaultNoSelect
	dashboardTitle.setAttributes {x:config.dashboard.x+10, y:config.dashboard.y+16, id:"dashboardTitle"}

	dashboardLink = new Node svg, "a"
	dashboardLink.setAttributes {"xlink:href":"", "href":"", id:"dashboardLink", target:"_blank"}

	# Innertext can't be empty because the embedded JS needs to be able to change the text
	dashboardSatisfaction = new Node svg, "text", " "
	dashboardSatisfaction.setAttributes {x:config.dashboard.x+10, y:config.dashboard.y+41, id:"dashboardSatisfaction"}

	dashboardLinkText = new Node dashboardLink, "text", " "
	dashboardLinkText.setAttributes {x:config.dashboard.x+10, y:config.dashboard.y+66, id:"dashboardLinkText"}

	### CSS ###
	svg.setEmbeddedCSS defaultCSS, config.styling

	svg
