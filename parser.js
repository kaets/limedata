const fs = require('fs');
const glob = require('glob');

//fs.appendFileSync('yum.csv', "lat,lng,rate_plan,status,last_three,last_activity_at,type_name,battery_level,meter_range\n"); // i know its more efficient to write one string once but im lazy
glob("*_l.json", null, function (er, files) {
	files.forEach(function(elt){
		let fetched = elt.split('_')[0];
console.log(elt);
		let rawdata = fs.readFileSync(elt,'utf-8');
		if (rawdata === "") return;
		var yo = JSON.parse(rawdata).data.attributes.bikes;
		yo.forEach((bike)=>{
			fs.appendFileSync('yum.csv', bike.attributes.latitude + "," + bike.attributes.longitude + "," + fetched + "," + bike.attributes.rate_plan.replace(/\n/g, "") + "," + bike.attributes.status + "," + bike.attributes.last_three + "," + bike.attributes.last_activity_at + "," + bike.attributes.type_name + "," + bike.attributes.battery_level + "," + bike.attributes.meter_range + "\n");
		});
	});
});

