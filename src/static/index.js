// pull in desired CSS/SASS files
require( './styles/main.scss' );

// inject bundled Elm app into div#main
const Elm = require( '../elm/Main' );

// Get authorization_token from localstorage if set
const token = localStorage.getItem('authorization_token');

const app = Elm.Main.embed( document.getElementById( 'main' ), {
  apiUrl: process.env.API_URL,
  token: token || '',
});

app.ports.saveToken.subscribe((token) => {
  localStorage.setItem('authorization_token', token);
});

app.ports.clearToken.subscribe(() => {
  localStorage.removeItem('authorization_token');
});
