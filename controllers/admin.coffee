bucket = require("bucket-node").bucket
_      = require "underscore"
flash = require "connect-flash"


#ADMIN SITE

exports.authenticateAdmin = (req, res, next) ->
	if req.session.user?
		next()
	else
		res.redirect "/admin"
		
exports.index = (req, res) ->
	aboutUs = bucket.where {type: "aboutUs"}
	contact = bucket.where {type: "contact"}
	other = bucket.where {type: "other"}
	
	if aboutUs.length > 0  and contact.length > 0 and other.length > 0
		res.render "admin/index",
			aboutUs: aboutUs.pop()
			contact: contact.pop()
			other: other.pop()
	else if aboutUs.length == 0
		storePost "Lorem ipsum..", "Title", "aboutUs", "new", (err) ->
		exports.index req, res
	else if contact.length == 0
		storePost "Lorem ipsum..", "Title", "contact", "new", (err) ->
		exports.index req, res
	else if other.length == 0
		storePost "Lorem ipsum..", "Title", "other", "new", (err) ->
		exports.index req, res

exports.edit = (req, res) ->
  Id = req.params.id
  textPost = bucket.getById(Id)

  res.render "admin/edit",
    textPost: textPost


storePost = (text, title, type, id, callback) ->
	if id = "new"
		blogPost = {}
		blogPost = {type: type}
		blogPost = _.extend(blogPost, {title: title, text: text})
		bucket.set(blogPost)
		bucket.store (err) ->
			callback(err)
	else
		blogPost = bucket.getById(id:id)
		blogPost = _.extend(blogPost, {title: title, text: text, type: type, id:id})
		bucket.set (blogPost)
		bucket.store (err) ->
			callback(err)

exports.savePost = (req, res) ->
	text = req.body.text
	title = req.body.title
	type = req.body.type
	id = req.params.id

	storePost text, title, type, id, (err) ->
		if err?
			req.flash('info', 'Something went wrong when saving blog post.')
		else
			req.flash('info', 'Saved.')
		exports.index req, res


		




