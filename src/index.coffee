exports.generateMap = (require './generateMap').generateMap
embeddedJS = (require './embeddedJS')

# Client side
if global.window?
	global.window.mapReporting = {
		generateMap : (config, zones) ->
			# Fill the window.mapReporting object with the handler methods
			embeddedJS.setClientScope @, config.labels
			module.exports.generateMap config, zones
	}
