mapUtils = require "./mapUtils.coffee"
geometry = require "./geometry.coffee";

class SVG
	constructor: () ->
		@head = new Node null, "svg"
		@head.setAttributes {id:"head", version:"1.1", baseProfile:"full", xmlns:"http://www.w3.org/2000/svg", "xmlns:xlink":"http://www.w3.org/1999/xlink"}
		@defs = new Node @head, "defs"
		@nbFilters = 0

	addDef: (def, id) ->
		def.setAttributes {"id": "f"+id}
		def.setParent @defs
		"f"+id

	setEmbeddedJS: (js) ->
		embedded = new Node @head, "script", js
		embedded.setAttributes {"type": "text/javascript"}

	_addChild: (obj) -> # Don't call directly, use the Node constructor instead
		@head._addChild obj
		@

	setAttributes: (obj) ->
		for k,v of obj
			@head.attributes[k] = v
		@

	toString: () ->
		"<?xml version=\"1.0\" standalone=\"no\"?>\n"+@head.toString(0)

class Node
	constructor: (@parent, @type, @inner="") -> # Don't call directly, use the Node constructor
		@children = []
		@attributes = {}
		@parent?._addChild @

	setParent: (obj) -> # Be careful with this.. or a node could end up in multiple places in the tree
		if not @parent?
			@parent = obj
			@parent._addChild @
		@

	_addChild: (obj) ->
		@children.push obj
		@

	setInner: (inner) ->
		@inner = inner
		@

	setAttributes: (obj) ->
		for k,v of obj
			@attributes[k] = v
		@

	toString: (indent=0) -> # Recursively build the XML tree by calling toString on the children nodes
		ret = mapUtils.strRepeat("\t", indent)+"<"+@type+(" "+k+"=\""+v+"\"" for k,v of @attributes).join("")
		if @inner.length > 0 or @children.length > 0
			ret += ">"+@inner+
				("\n"+node.toString(indent+1) for node in @children).join("")+
				"\n"+mapUtils.strRepeat("\t", indent)+"</"+@type+">"
		else
			ret += " />"

scores = [0.29, 0.4, 0.45, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95].reverse()
class Shape
	constructor: (@id, @link, @name) ->
		@link = encodeURI @link
		@name = mapUtils.toHTML @name
		@coordinates = [] # Basic coordinates, used to find the shape's center
		@d = ""
		pair = "\[[0-9]{1,5}(\.[0-9]{1,5})?,[0-9]{1,5}(\.[0-9]{1,5})?\]"
		@regexes =
			arc : new RegExp "^arc\["+pair+","+pair+","+pair+"\]$"
			pie : new RegExp "^pie\["+pair+","+pair+","+pair+"\]$"

	firstInstruction: () ->
		if @coordinates.length == 0 then "M " else "L "

	addVector: (vector, dx, dy) ->
		if @regexes.arc.test vector then @.addArc vector[3..], dx, dy
		else if @regexes.pie.test vector then @.addPie vector[3..], dx, dy
		else @addPoint vector, dx, dy
		@

	addPoint: (vector, dx, dy) ->
		try
			[x, y] = JSON.parse vector
			[x, y] = [x+dx, y+dy]
			@d += @firstInstruction()+x+" "+y+" "
			@coordinates.push [x, y]
		catch err
			console.log "Can't parse "+vector
		@

	# A = start, B = end, C = point on the arc
	addArc: (vector, dx, dy) ->
		try
			[[xa, ya], [xb, yb], [xc, yc]] = (JSON.parse vector).map ([x, y]) -> [x+dx, y+dy]
			try
				{r1, r2, xcenter, ycenter, angle, sweep} = geometry.calculateEllipse xa, ya, xb, yb, xc, yc
				@d += @firstInstruction()+xa+" "+ya+" A "+r1+" "+r2+" "+(-angle)+" 0 "+sweep+" "+xb+" "+yb+" "
			catch err
				# Draw lines instead if it failed due to bad coordinates
				@d += @firstInstruction()+xa+" "+ya+" L "+xc+" "+yc+" L "+xb+" "+yb
			@coordinates.push [xa, ya], [xb, yb]
		catch err
			console.log "Can't parse "+vector
		@

	# A = start, B = end, C = center
	addPie: (vector, dx, dy) ->
		try
			[[xa, ya], [xb, yb], [xc, yc]] = (JSON.parse vector).map ([x, y]) -> [x+dx, y+dy]
			{r, large} = geometry.calculatePie xa, ya, xb, yb, xc, yc
			@d += @firstInstruction()+xa+" "+ya+" A "+r+" "+r+" 0 "+large+" 1 "+xb+" "+yb+" "
			@coordinates.push [xa, ya], [xb, yb], [xc, yc]
		catch err
			console.log "Can't parse "+vector
		@

	findCenter: () ->
		avgx = geometry.avg [@coordinates[@coordinates.length-1][0], @coordinates[0][0], @coordinates[1][0]]
		avgy = geometry.avg [@coordinates[@coordinates.length-1][1], @coordinates[0][1], @coordinates[1][1]]
		[avgx, avgy]

	createFilter: (stroke, radialColor) ->
		filter = new Node null, "radialGradient"
		innerFilter1 = new Node filter, "stop"
		innerFilter1.setAttributes {offset:"35%", "stop-color":radialColor, "stop-opacity":"0.5"}
		innerFilter2 = new Node filter, "stop"
		innerFilter2.setAttributes {offset:"99%", "stop-color":stroke, "stop-opacity":"0.8"}
		filter

	addToSVG: (svg, initial, alternate) ->
		# Create node and set its attributes
		node = new Node svg, "path"
		node.setAttributes {id:@id, name:@name, link:@link+@name, d:@d+"Z"}

		# Generate colors and then add stroke attributes
		score = Math.random()
		# score = if scores.length > 0 then scores.shift() else 0.1
		# console.log @name+" "+score
		if score >= 0.4
			val = score*100

			colors = {
				green : mapUtils.getColor ((val-70)/30*100), "green", false
				blue : mapUtils.getColor ((val-70)/30*100), "blue", false
				red : mapUtils.getColor ((val-40)/30*100), "red", true
			}
			if val > 70
				node.setAttributes {class:"good"}
				initialColor = colors[initial]
				alternateColor = colors[alternate]
				stroke = initialColor
				radialGradient = initial # Could be changed in the future
				initialFilter = svg.addDef (@createFilter initialColor, initialColor), @id+"initial"
				alternateFilter = svg.addDef (@createFilter alternateColor, alternateColor), @id+"alternate"
				node.setAttributes {"fill":"url(#"+initialFilter+")", initialFilter, alternateFilter,\
					initialColor, alternateColor}
			else
				node.setAttributes {class:"bad"}
				stroke = colors.red
				radialGradient = stroke # Could be changed in the future
				filter = svg.addDef (@createFilter colors.red, colors.red), @id+"initial"
				node.setAttributes {fill:"url(#"+filter+")"}

			# console.log r+" "+g+" "+b
			value = Math.round(score*100)+"%"

		else
			stroke = "#FFFFFF"
			radialColor = "#AAAAAA"
			value = "--"
			node.setAttributes {fill:"url(#fdashed)"}

		node.setAttributes {value, stroke:stroke, "stroke-width":4, "stroke-opacity":"0.4"}

		# Add javascript event hooks
		node.setAttributes {onmouseover:"mouseOver(evt);", onmouseout:"mouseOut(evt);", onmousedown:"mouseDown(evt);"}

		# Place id
		[x, y] = @findCenter()
		id = new Node svg, "text", @id
		id.setAttributes {id:"id"+@id, x, y, "font-family":"Courier", "font-size":"32px", fill:"#000000", stroke:"#000000",\
			"stroke-width":2, style:"text-anchor: middle"}

		@

module.exports = {SVG, Node, Shape}