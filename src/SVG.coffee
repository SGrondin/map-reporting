mapUtils = require "./mapUtils"
Node = (require "./Node").Node

class exports.SVG
	constructor: () ->
		@head = new Node null, "svg"
		@head.setAttributes {class:"mapReporting", version:"1.1", baseProfile:"full", xmlns:"http://www.w3.org/2000/svg", "xmlns:xlink":"http://www.w3.org/1999/xlink"}
		@defs = new Node @head, "defs"
		@script = new Node @head, "script"
		@script.setAttributes {"type":"text/javascript"}
		@style = new Node @head, "style"
		@style.setAttributes {type:"text/css"}
		@css = {defaultCSS:"", styling:""} # Hold CSS here until toString or toDOM are called

	addDef: (def, id) ->
		def.setAttributes {"id": "f"+id}
		def.setParent @defs
		"f"+id

	setEmbeddedJS: (js) ->
		@script.setCDATA js
		@

	setEmbeddedCSS: (defaultCSS, styling) ->
		@css = {defaultCSS, styling}
		@

	_addChild: (obj) -> # Don't call directly, use the Node constructor instead
		@head._addChild obj
		@

	setAttributes: (obj) ->
		for k,v of obj
			@head.attributes[k] = v
		@

	toString: () ->
		@style.setCDATA @css.defaultCSS+"\n"+(mapUtils.buildCSS @css.styling)
		"<?xml version=\"1.0\" standalone=\"no\"?>\n"+@head.toString(0)

	toDOM: (containerID) ->
		container = document.getElementById containerID
		@style.setCDATA @css.defaultCSS+"\n"+(mapUtils.buildCSS @css.styling, containerID)
		@head.toDOM container
		@
