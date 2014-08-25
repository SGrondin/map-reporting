exports.getEmbeddedJS = (labels) ->
	scope = module.exports.setClientScope {}, labels
	embedded = "\n<![CDATA[\n"
	embedded += "var mapReporting = {"
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
	scope.toArray = (obj) -> Array::slice.call obj, 0
	scope.removeClass = (element, name) ->
		element.setAttribute("class", element.getAttribute("class").split(" ").filter((a) -> a != name).join(" "))
	scope.removeAllClass = (name) ->
		@removeClass selected, name for selected in @toArray @head.querySelectorAll "."+name
	scope.addClass = (element, name) ->
		arr = element.getAttribute("class").split " "
		arr.push name
		element.setAttribute("class", arr.join " ")
	scope.hasClass = (element, name) ->
		(element.getAttribute("class").split " ").indexOf(name) >= 0
	scope.somethingIsSelected = () ->
		(@toArray @head.querySelectorAll(".selected"), 0).length > 0
	scope.displayShapeInDashboard = (shape) ->
		@head.querySelector("#dashboardTitle").firstChild.nodeValue = shape.getAttribute("id")+" "+shape.getAttribute("name")
		@head.querySelector("#dashboardLink").setAttribute("xlink:href", shape.getAttribute("link").replace(/&/g, "%26"))
		@head.querySelector("#dashboardLink").setAttribute("href", shape.getAttribute("link").replace(/&/g, "%26"))
		if @labels.link? then @head.querySelector("#dashboardLinkText").firstChild.nodeValue = @labels.link
		@head.querySelector("#dashboardSatisfaction").firstChild.nodeValue = @labels.value+shape.getAttribute("value")
	scope.emptyDashboard = () ->
		@head.querySelector("#dashboardTitle").firstChild.nodeValue = @labels.defaultNoSelect
		@head.querySelector("#dashboardLinkText").firstChild.nodeValue = ""
		@head.querySelector("#dashboardSatisfaction").firstChild.nodeValue = ""
	scope.displaySelected = () ->
		@displayShapeInDashboard selected for selected in (@toArray @head.querySelectorAll ".selected")
	scope.putOnTop = (shape) ->
		@head.appendChild(shape)
		id = @head.querySelector "#id"+shape.getAttribute("id")
		if id? then @head.appendChild(id)
	scope.putSelectedOnTop = () ->
		@putOnTop selected for selected in @toArray @head.querySelectorAll ".selected"

	# LISTENERS
	scope.mouseOver = (shape) ->
		@head = shape.parentNode
		if not @hasClass shape, "selected" then @addClass shape, "hovered"
		@putOnTop shape
		@putSelectedOnTop()
		@displayShapeInDashboard shape
	scope.mouseOut = (shape) ->
		@head = shape.parentNode
		@removeClass shape, "hovered"
		if @somethingIsSelected()
			@displaySelected()
		else
			@emptyDashboard()
	scope.mouseDown = (shape) ->
		@head = shape.parentNode
		isSelected = @hasClass shape, "selected"
		@removeAllClass "selected"
		if isSelected
			@addClass shape, "hovered"
		else
			@removeClass shape, "hovered"
			@addClass shape, "selected"
		@putOnTop shape
	scope.shapeOver = (evt) ->	@mouseOver evt.target
	scope.shapeOut = (evt) ->	@mouseOut evt.target
	scope.shapeDown = (evt) ->	@mouseDown evt.target
	scope.IDover = (evt) ->		@mouseOver evt.target.parentNode.querySelector "#"+evt.target.getAttribute("id")[2..]
	scope.IDout = (evt) ->		@mouseOut evt.target.parentNode.querySelector "#"+evt.target.getAttribute("id")[2..]
	scope.IDdown = (evt) ->		@mouseDown evt.target.parentNode.querySelector "#"+evt.target.getAttribute("id")[2..]
	scope.changeScaleColor = (evt) ->
		@head = evt.target.parentNode.parentNode
		elements = @toArray @head.querySelectorAll ".good"
		for element in elements
			if @usingAlternateColor
				element.setAttribute "fill", "url(#"+element.getAttribute("initialfilter")+")"
				element.setAttribute "stroke", element.getAttribute "initialcolor"
			else
				element.setAttribute "fill", "url(#"+element.getAttribute("alternatefilter")+")"
				element.setAttribute "stroke", element.getAttribute "alternatecolor"
		@usingAlternateColor = !@usingAlternateColor
	scope
