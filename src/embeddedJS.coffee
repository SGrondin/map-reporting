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
	scope.labels = labels
	scope.removeClass = (element, name) ->
		element.setAttribute("class", element.getAttribute("class").split(" ").filter((a) -> a != name).join(" "))
	scope.removeAllClass = (name) ->
		@.removeClass selected, name for selected in document.getElementsByClassName name
	scope.addClass = (element, name) ->
		arr = element.getAttribute("class").split " "
		arr.push name
		element.setAttribute("class", arr.join " ")
	scope.hasClass = (element, name) ->
		(element.getAttribute("class").split " ").indexOf(name) >= 0
	scope.somethingIsSelected = () ->
		(document.getElementsByClassName "selected").length > 0
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
	scope.displaySelected = () ->
		@.displayShapeInDashboard selected for selected in (document.getElementsByClassName "selected")
	scope.putOnTop = (shape) ->
		document.getElementById("head").appendChild(shape)
		id = document.getElementById("id"+shape.getAttribute("id"))
		if id? then document.getElementById("head").appendChild(id)
	scope.putSelectedOnTop = () ->
		@.putOnTop selected for selected in document.getElementsByClassName "selected"

	# LISTENERS
	scope.mouseOver = (shape) ->
		if not @.hasClass shape, "selected" then @.addClass shape, "hovered"
		@.putOnTop shape
		@.putSelectedOnTop()
		@.displayShapeInDashboard shape
	scope.mouseOut = (shape) ->
		@.removeClass shape, "hovered"
		if @.somethingIsSelected()
			@.displaySelected()
		else
			@.emptyDashboard()
	scope.mouseDown = (shape) ->
		isSelected = @.hasClass shape, "selected"
		@.removeAllClass "selected"
		if isSelected
			@.addClass shape, "hovered"
		else
			@.removeClass shape, "hovered"
			@.addClass shape, "selected"
		@.putOnTop shape
	scope.shapeOver = (evt) ->	@.mouseOver evt.target
	scope.shapeOut = (evt) ->	@.mouseOut evt.target
	scope.shapeDown = (evt) ->	@.mouseDown evt.target
	scope.IDover = (evt) ->	@.mouseOver document.getElementById evt.target.getAttribute("id")[2..]
	scope.IDout = (evt) ->	@.mouseOut document.getElementById evt.target.getAttribute("id")[2..]
	scope.IDdown = (evt) ->	@.mouseDown document.getElementById evt.target.getAttribute("id")[2..]
	scope.changeScaleColor = (evt) ->
		elements = document.getElementsByClassName "good"
		for element in elements
			if @.usingAlternateColor
				element.setAttribute "fill", "url(#"+element.getAttribute("initialFilter")+")"
				element.setAttribute "stroke", element.getAttribute "initialColor"
			else
				element.setAttribute "fill", "url(#"+element.getAttribute("alternateFilter")+")"
				element.setAttribute "stroke", element.getAttribute "alternateColor"
		@.usingAlternateColor = !@.usingAlternateColor
	scope
