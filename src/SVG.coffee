mapUtils = require "./mapUtils"
Node = (require "./Node").Node

class exports.SVG
	constructor: (config, zones) ->
		@head = new Node null, "svg"
		@head.setAttributes {class:"mapReporting", version:"1.1", baseProfile:"full",\
			xmlns:"http://www.w3.org/2000/svg", "xmlns:xlink":"http://www.w3.org/1999/xlink",\
			id:"mapReporting"+mapUtils.hash(JSON.stringify(config)+JSON.stringify(zones))+"_"+Math.round(Math.random()*99999999),
			width:config.width, height:config.height, viewBox:"0 0 "+config.width+" "+config.height, preserveAspectRatio:"XMidYMid meet"
		}
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

	setEmbeddedCSS: (defaultCSS, styling) ->
		@style.setCDATA defaultCSS+"\n"+(mapUtils.buildCSS styling, @head.attributes.id)
		@

	_addChild: (obj) -> # Don't call directly, use the Node constructor instead
		@head._addChild obj
		@

	setAttributes: (obj) ->
		@head.setAttributes obj
		@

	toString: () ->
		"<?xml version=\"1.0\" standalone=\"no\"?>\n"+@head.toString(0)

	toDOM: (refOrID) ->
		container = if typeof refOrID == "string" then document.getElementById refOrID else refOrID
		@head.toDOM container
		@
