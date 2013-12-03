mapUtils = require "./mapUtils"

class exports.Node
	constructor: (@parent, @type, @inner="", @cdata="") ->
		@children = []
		@attributes = {}
		@parent?._addChild @

	setParent: (obj) -> # Be careful with this.. or a node could end up in multiple places in the tree
		if not @parent?
			@parent = obj
			@parent._addChild @
		@

	_addChild: (obj) -> # Don't call directly, use the child Node's constructor
		@children.push obj
		@

	setInner: (@inner) ->
		@

	setCDATA: (@cdata) ->
		@

	setAttributes: (obj) ->
		for k,v of obj
			@attributes[k] = v
		@

	toString: (indent=0) -> # Recursively build the XML tree by calling toString on the children nodes
		ret = mapUtils.strRepeat("\t", indent)+"<"+@type+(" "+k+"=\""+v+"\"" for k,v of @attributes).join("")
		if @inner.length > 0 or @cdata.length > 0 or @children.length > 0
			ret += ">"+@inner+@cdata+
				("\n"+node.toString(indent+1) for node in @children).join("")+
				"\n"+mapUtils.strRepeat("\t", indent)+"</"+@type+">"
		else
			ret += " />"

	toDOM: (addTo, test) ->
		el = document.createElementNS "http://www.w3.org/2000/svg", @type
		if @inner.length > 0 then el.appendChild document.createTextNode @inner
		if @cdata.length > 0 and @type != "script" then el.appendChild document.createTextNode @cdata
		for k,v of @attributes
			if k != "xlink:href"
				el.setAttribute k, v
			else
				el.setAttributeNS('http://www.w3.org/1999/xlink', k, v)
		for c in @children
			c.toDOM el
		addTo.appendChild el
