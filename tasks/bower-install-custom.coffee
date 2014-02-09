#
# * grunt-bower-install-custom
# *
# * License tbd
#

"use strict"

module.exports = (grunt) ->

	# required modules
	fs = require("fs")
	path = require("path")
	util = require "util"

	# global storage for files
	files =
		js : []
		css : []

	# method to add files
	add = (file) ->

		if path.extname(file) == '.css'
			files.css.push(file)

		if path.extname(file) == '.js'
			files.js.push(file)

	generateCode = ->
			js = ""
			css = ""
			for file in files.js
				# console.log "<script src=\"" + file + "\"></script>\n"
				js +=  "<script src=\"" + file + "\"></script>\n"

			for file in files.css
				# console.log "<script src=\"" + file + "\"></script>\n"
				css +=  "<link rel=\"stylesheet\" href=\"" + file + "\" />\n"

			return {
				js : js
				css : css
			}

	replaceBower = (html, code) ->
		# console.log 'html = \n' + html + '\n----'
		if code.css.length > 0
			# console.log "first: '" + code.css + "'"
			# html = html.replace(/<!-- bower:css-->((?:.*\\r?\\n?)*)<!-- endbower-->/, "TEMP" + "\n" + code.css )
			html = html.replace(/<\/head>/, code.css+ "\n</head>"  )
		if code.js.length > 0
			# console.log "second: '" + code.js + "'"
			# html = html.replace('\/<!-- bower:js-->((?:.*\\r?\\n?)*)<!-- endbower-->\/', "$1" + "\n" + code.js )
			html = html.replace(/<\/head>/, code.js + "\n</head>" )
		return html


	grunt.registerMultiTask "bower-install-custom", "Install Bower packages packages that were not configured correctly.", ->
		# reset js and css values for this run
		file.js = []
		file.css = []

		options = @options(
			config : 'bower-install-custom.json'
		)


		if options.html
			grunt.log.ok "Found html file " + options.html.grey

		if fs.existsSync options.html
			grunt.log.ok "HTML file exists, loading ..."
			htmlContent = fs.readFileSync options.html,
				encoding : 'utf8'

		if fs.existsSync(options.config)
			grunt.log.ok "Found config file " + options.config.grey

			config = JSON.parse(fs.readFileSync(options.config))

			console.log config
			config.modules.forEach (module) ->
				grunt.log.ok 'Module `' + module[0] + '` with files: ' + module[1]
				module[1].forEach (file) ->
					if(htmlContent.indexOf(file) >= 0)
						grunt.log.error 'bower-install has already installed `' + file.grey + '` for module `' + module[0]+'`'
					else
						grunt.log.ok 'bower-install missed `' + file.grey + '` for module `' + module[0]+'`'
						add ( config.localpath + "/" + module[0] + "/" + file)

			# console.log "start replacing ..."
			replacedCode = replaceBower(htmlContent, generateCode())
			# console.log "end replacing ..."
			fs.writeFileSync options.html, replacedCode
