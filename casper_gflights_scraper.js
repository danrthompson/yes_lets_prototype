var links = [];
var casper = require('casper').create();

// origin = 'SFO'
// destination = 'NYC'
// origin_and_dest_classes = 'GAJ4KBDCELB GAJ4KBDCPKB'
// origin_tab_index = '1'
// dest_tab_index = '2'



casper.start('http://www.google.com/flights/', function() {
    // search for 'casperjs' from google form
    this.fill('form[action="/search"]', { q: 'casperjs' }, true);
});