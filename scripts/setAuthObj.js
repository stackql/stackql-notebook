const fs = require('fs');
const data = fs.readFileSync('/config/providerAuth.json',
            {encoding:'utf8', flag:'r'});
const jsonData = JSON.parse(data);
console.log(JSON.stringify(jsonData));
