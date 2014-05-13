bucket = require("bucket-node").bucket
_      = require "underscore"


exports.login = (req, res) ->
	res.render("login")


exports.loginAdmin = (req, res) ->
	username = req.body.username
	password = req.body.password
	user = bucket.findWhere {type: "adminUser", name: username, password: password}
	if user? && _.contains user.permissions, "ksite"
		req.session.user = user
		res.redirect ("/admin/index")
	else
		res.redirect "/admin"

exports.authenticateAdmin = (req, res, next) ->
	if req.session.user?
		next()
	else
		res.redirect "/admin"

exports.index = (req, res) ->
	res.render("admin/index")