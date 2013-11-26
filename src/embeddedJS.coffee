exports.getEmbeddedJS = (labels) ->
	scope = module.exports.setClientScope {}, labels
	embedded = "\n<![CDATA[\n"
	embedded += "var scope = mapReporting = {"
	for k,v of scope
		embedded += "\n"+k+" : "
		embedded += if v? and typeof v == "function"
			v.toString()
		else if v? and typeof v == "object"
			JSON.stringify v
		else
			null
		embedded += ","
	embedded += "};\n]]>"

exports.setClientScope = (scope, labels) ->
	scope.usingAlternateColor = false
	scope.hoveredStroke = null
	scope.selectedShape = null
	scope.selectedStroke = null
	scope.labels = labels
	scope.displayShapeInDashboard = (shape) ->
		document.getElementById("dashboardTitle").firstChild.nodeValue = shape.getAttribute("id")+" "+shape.getAttribute("name")
		document.getElementById("dashboardLink").setAttribute("xlink:href", shape.getAttribute("link").replace(/&/g, "%26"))
		document.getElementById("dashboardLink").setAttribute("href", shape.getAttribute("link").replace(/&/g, "%26"))
		document.getElementById("dashboardLinkText").firstChild.nodeValue = @.labels.link
		document.getElementById("dashboardSatisfaction").firstChild.nodeValue = @.labels.value+shape.getAttribute("value")
	scope.emptyDashboard = () ->
		document.getElementById("dashboardTitle").firstChild.nodeValue = "Nothing selected"
		document.getElementById("dashboardLinkText").firstChild.nodeValue = ""
		document.getElementById("dashboardSatisfaction").firstChild.nodeValue = ""
	scope.putOnTop = (shape) ->
		@.displayShapeInDashboard(shape)
		document.getElementById("head").appendChild(shape)
		id = document.getElementById("id"+shape.getAttribute("id"))
		if id != null then document.getElementById("head").appendChild(id)
	scope.selectShape = (shape) ->
		@.selectedShape = shape
		@.selectedStroke = @.hoveredStroke
		shape.setAttribute("stroke", "#000000")
		shape.setAttribute("stroke-opacity", "1")
		shape.setAttribute("stroke-width", "6")
		shape.removeAttribute("stroke-dasharray")
	scope.releaseShape = () ->
		@.selectedShape.setAttribute("stroke", @.selectedStroke)
		@.selectedShape.setAttribute("stroke-width", "4")
		@.selectedShape.setAttribute("stroke-opacity", "0.4")
		@.selectedStroke = null
		@.selectedShape = null
	scope.mouseOver = (evt) ->
		@.putOnTop(evt.target)
		if evt.target != @.selectedShape
			@.hoveredStroke = evt.target.getAttribute("stroke")
			evt.target.setAttribute("stroke", "#000000")
			evt.target.setAttribute("stroke-opacity", "1")
			evt.target.setAttribute("stroke-width", "6")
			evt.target.setAttribute("stroke-dasharray", "12,8")
	scope.mouseOut = (evt) ->
		if @.selectedShape != null
			@.putOnTop(@.selectedShape)
		else
			@.emptyDashboard()
		evt.target.removeAttribute("stroke-dasharray")
		if evt.target != @.selectedShape
			evt.target.setAttribute("stroke", @.hoveredStroke)
			evt.target.setAttribute("stroke-opacity", "0.4")
			evt.target.setAttribute("stroke-width", "4")
	scope.mouseDown = (evt) ->
		if @.selectedShape == null
			@.selectShape(evt.target)
		else if evt.target == @.selectedShape
			@.hoveredStroke = @.selectedStroke
			@.selectedStroke = null
			@.selectedShape = null
			evt.target.setAttribute("stroke-dasharray", "12,8")
		else
			@.releaseShape()
			@.selectShape(evt.target)
	scope.changeScaleColor = (evt) ->
		elements = document.getElementsByClassName("good")
		for element in elements
			if @.usingAlternateColor
				element.setAttribute("fill", "url(#"+element.getAttribute("initialFilter")+")")
				element.setAttribute("stroke", element.getAttribute("initialColor"))
			else
				element.setAttribute("fill", "url(#"+element.getAttribute("alternateFilter")+")")
				element.setAttribute("stroke", element.getAttribute("alternateColor"))
		@.usingAlternateColor = !@.usingAlternateColor
	scope
