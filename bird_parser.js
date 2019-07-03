const fs = require('fs');
const glob = require('glob');

//fs.appendFileSync('bird.csv', "lat,lng,code,model,captive,nest_id,battery,id,fetched\n"); // i know its more efficient to write one string once but im lazy
glob("*_b.json", null, function (er, files) {
	files.forEach(function(elt){
		let fetched = elt.split('_')[0];
		let rawdata = fs.readFileSync(elt,'utf-8');
		if (rawdata === "") return;
		var scooters = JSON.parse(rawdata).birds;
		scooters.forEach((bike)=>{
			fs.appendFileSync('bird.csv', bike.location.latitude + "," + bike.location.longitude + "," + bike.code + "," + bike.model + "," + bike.captive + "," + bike.nest_id + "," + bike.battery_level + "," + bike.id + "," + fetched + "\n");
		});
		
	});
});
