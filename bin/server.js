/**
 * Run a static server
 *
 * configured in .settings/launch.json
 *
 */
var server = require('superstatic').server;
var open = require('open');
var path = require('path');

var options = {
	port: 3474,
	host: 'localhost',
	config: {
		root: './web',
		routes: {
			'/': 'index.html'
		}
	},
	cwd: path.resolve(__dirname, '..'),
	debug: false	
};

server(options).listen(function(err) {
	open('http://localhost:3474');
});
