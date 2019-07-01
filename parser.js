const fs = require('fs');
const glob = require('glob');

//fs.appendFileSync('yum.csv', "lat,lng\n"); // i know its more efficient to write one string once but im lazy
glob("*_l.json", null, function (er, files) {
	files.forEach(function(elt){
		let rawdata = fs.readFileSync(elt);
		var yo = JSON.parse(rawdata).data.attributes.bikes
		yo.forEach((bike)=>{
			fs.appendFileSync('yum.csv', bike.attributes.latitude + "," + bike.attributes.longitude + "\n");
		});
	});
});

