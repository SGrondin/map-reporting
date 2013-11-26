Node = (require "./Node").Node

class exports.SVG
	constructor: () ->
		@head = new Node null, "svg"
		@head.setAttributes {id:"head", version:"1.1", baseProfile:"full", xmlns:"http://www.w3.org/2000/svg", "xmlns:xlink":"http://www.w3.org/1999/xlink"}
		@defs = new Node @head, "defs"

	addDef: (def, id) ->
		def.setAttributes {"id": "f"+id}
		def.setParent @defs
		"f"+id

	setEmbeddedJS: (js) ->
		script = new Node @head, "script", "", js
		script.setAttributes {"type": "text/javascript"}
		@

	_addChild: (obj) -> # Don't call directly, use the Node constructor instead
		@head._addChild obj
		@

	setAttributes: (obj) ->
		for k,v of obj
			@head.attributes[k] = v
		@

	toString: () ->
		"<?xml version=\"1.0\" standalone=\"no\"?>\n"+@head.toString(0)

	toDOM: (containerID, d3) ->
		el = d3.select("#"+containerID)
		@head.toDOM el
		@
