var fs = require('fs');
var path = require('path');

// Wrapper for ASG-specific parsing
var ASGParser = function () {

		// Generate nagios config from instance element
		function generateConfigForInstance (inst, cb) {
			var s = "define host {";
			s += "\n\tuse\t\tlinux-server";
			s += "\n\thost_name\t" + inst.Name;
			s += "\n\talias\t\t" + inst.Name + "," + inst.PrivateIpAddress + "," + inst.InstanceId;
			s += "\n\taddress\t\t" + inst.PrivateIpAddress;
			s += "\n\thostgroups\t" + inst.service + ((typeof inst.scope !== 'undefined')?("-" + inst.scope):"") + "-servers";
			s += "\n}";
			return cb(null, s);
		} 
		
		// Get config for each instance, return the combined string
		function processInstanceArray (instances, cb) {
			var configs = [];
			instances.forEach(function (inst, ind) {
					// add tags as top-level properties to facilitate further processing
					inst.Tags.forEach(function (tag) {
						inst[tag.Key] = tag.Value;	
					});
					if (inst["State"]["Name"] === "running") {
							generateConfigForInstance(inst, function (err, configString) {
								configs.push(configString);
								if (ind === instances.length - 1) return cb(null, configs);
							});
					}
					else if (ind === instances.length - 1) {
							return cb(null, configs);
					}
			});
		}

		// Retrieve instances from the Reservation array
		function getInstanceArray (data, cb) {
			var data = JSON.parse(data);
			var reservations = data["Reservations"];
			var instances = [];
			reservations.forEach(function(res, ind){
				instances = instances.concat(res["Instances"]);
				if (ind === reservations.length - 1) return cb(null, instances);
			});
		}

		// Only public function in this object - triggers parsing and processing of the inputString
		this.generateConfig = function generateConfig (inputString, cb) {
			getInstanceArray(inputString, function(err, instances){
				processInstanceArray(instances, cb);
			});
		}
}

// Read input from stdin (done to facilitate piping)
function readInput (cb) {
		var data = "";
		process.stdin.on('data', function (chunk) {
			if (chunk === null) {
				return cb (new Error("Nothing to read"));
			}
			else {
				data += chunk.toString();
			}
		});

		process.stdin.on('end', function () {
			return cb(null, data);
		});
}


// Program entry-point
readInput (function (err, data) {
	if (err) process.exit(1);
	else return new ASGParser().generateConfig(data, function (err, configs) {
			if (err) process.exit(1);
			else console.log(configs.join("\n"));
		});
});

