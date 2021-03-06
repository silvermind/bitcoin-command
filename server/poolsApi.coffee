db = require('./db')
BSON = require('mongodb').BSONPure

exports.getAllPools = (req, res) ->
    db.pools.find().toArray (err, data) ->
        if err then throw err
        res.json data

exports.getPool = (req, res) ->
    id = new BSON.ObjectID(req.params.poolId)
    db.pools.findOne {_id: id }, (err, pool) ->
        if err then throw err
        unless pool?
            res.statusCode = 404
            res.json error: 'pool not found'
            return
        res.json pool

exports.savePool = (req, res) ->
    pool = req.body
    id = new BSON.ObjectID(req.params.poolId)
    delete pool._id
    delete pool.poolSize
    delete pool.pending
    delete pool.payouts
    db.pools.update {_id: id}, {$set: pool}, {w:1}, (err) ->
        if err
            res.statusCode = 500
            res.json error: err
        res.end()

exports.deletePool = (req, res) ->
    id = new BSON.ObjectID(req.params.poolId)
    db.pools.remove {_id: id}, {w:1}, (err) ->
        if err
            res.statusCode = 500
            res.json error: err
        res.end()
