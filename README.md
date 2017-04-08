# Kilta CMS UI

## About:
[Elm](http://elm-lang.org/) front end for Directus based CMS for student organizations, [Kilta CMS](https://github.com/cadiac/kilta-cms).

The project was scaffolded using [elm-webpack-starter](https://github.com/elm-community/elm-webpack-starter). :star:


## Install:

Copy `.env.sample` into `.env`, and change the variables as desired.

Install all dependencies using the handy `reinstall` script:

```
yarn run reinstall
```
*This does a clean (re)install of all npm and elm packages, plus a global elm install.*


### Serve locally:
```
npm start
```
* Access app at `http://localhost:8080/`
* Get coding! The entry point file is `src/elm/Main.elm`
* Browser will refresh automatically on any file changes..


### Build & bundle for prod:
```
npm run build
```

* Files are saved into the `/dist` folder
* To check it, open `dist/index.html`
