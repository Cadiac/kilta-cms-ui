// pull in desired CSS/SASS files
require( './styles/main.scss' );

// inject bundled Elm app into div#main
var Elm = require( '../elm/Main' );

// Get authorization_token from localstorage if set
var token = localStorage.getItem('authorization_token');

var app = Elm.Main.embed( document.getElementById( 'main' ), {
  apiUrl: process.env.API_URL,
  token: token || '',
});

app.ports.saveToken.subscribe(function(token) {
  localStorage.setItem('authorization_token', token);
});

app.ports.clearToken.subscribe(function() {
  localStorage.removeItem('authorization_token');
});
