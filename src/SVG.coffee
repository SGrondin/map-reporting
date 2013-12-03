Node = (require "./Node").Node

class exports.SVG
	constructor: () ->
		@head = new Node null, "svg"
		@head.setAttributes {id:"head", version:"1.1", baseProfile:"full", xmlns:"http://www.w3.org/2000/svg", "xmlns:xlink":"http://www.w3.org/1999/xlink"}
		@defs = new Node @head, "defs"
		@script = new Node @head, "script"
		@script.setAttributes {"type":"text/javascript"}
		@style = new Node @head, "style"
		@style.setAttributes {type:"text/css"}

	addDef: (def, id) ->
		def.setAttributes {"id": "f"+id}
		def.setParent @defs
		"f"+id

	setEmbeddedJS: (js) ->
		@script.setCDATA js
		@

	setEmbeddedCSS: (style) ->
		@style.setCDATA style
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

	toDOM: (containerID) ->
		@head.toDOM document.getElementById containerID
		@
