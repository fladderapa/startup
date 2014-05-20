bucket = require("bucket-node").bucket
_      = require "underscore"
flash = require "connect-flash"

#exports.index = (req, res) ->
  #res.render("index")

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

exports.index = (req, res) ->
	aboutUs = bucket.where {type: "aboutUs"}
	contact = bucket.where {type: "contact"}
	other = bucket.where {type: "other"}
	
	if aboutUs.length > 0  and contact.length > 0 and other.length > 0
		res.render "index",
			aboutUs: aboutUs.pop()
			contact: contact.pop()
			other: other.pop()
	else 
		res.render "index",
