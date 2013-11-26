Node = (require "./Node").Node
mapUtils = require "./mapUtils"
geometry = require "./geometry"

class exports.Shape
	constructor: (@id, @link, @name, @val) ->
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

	addToSVG: (svg, initial, alternate, threshold, IDconfig) ->
		# Create node and set its attributes
		node = new Node svg, "path"
		node.setAttributes {id:@id, name:@name, link:@link, d:@d+"Z"}

		# Generate and add color attributes
		if @val? and @val != "" and threshold? and threshold != "" and (0 <= @val <= 100) and (0 <= threshold <= 100)
			colors = {
				green : mapUtils.getColor ((@val-threshold)/(100-threshold)*100), "green", false
				blue : mapUtils.getColor ((@val-threshold)/(100-threshold)*100), "blue", false
				red : mapUtils.getColor (@val/threshold*100), "red", true
			}
			if @val > 70
				node.setAttributes {class:"good"}
				initialColor = colors[initial]
				alternateColor = colors[alternate]
				stroke = initialColor
				radialGradient = stroke # Could be changed in the future
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

			value = @val+"%"

		else
			stroke = "#FFFFFF"
			radialColor = "#AAAAAA"
			value = "--"
			node.setAttributes {fill:"url(#fdashed)"}

		node.setAttributes {value, stroke:stroke, "stroke-width":4, "stroke-opacity":"0.4"}

		# Add javascript event hooks
		node.setAttributes {onmouseover:"mapReporting.mouseOver(evt);",\
			onmouseout:"mapReporting.mouseOut(evt);", onmousedown:"mapReporting.mouseDown(evt);"}

		# Place id
		if IDconfig.show
			[x, y] = @findCenter()
			id = new Node svg, "text", @id
			id.setAttributes {id:"id"+@id, x, y, "font-family":"Courier", "font-size":"32px", fill:IDconfig.color,\
				stroke:IDconfig.color, "stroke-width":2, style:"text-anchor: bottom"}

		@
