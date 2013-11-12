mapUtils = require "./mapUtils"

class exports.Node
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
