module Routing exposing (..)

import Dict exposing (Dict)

import Msgs exposing (Msg)
import Navigation exposing ( Location, newUrl )
import Models exposing ( NewsId, Model, Route(..) )
import Commands exposing (..)
import UrlParser exposing (..)

loginPath : String
loginPath =
  "login"

newsPath : String
newsPath =
  "news"

newsStoryPath : NewsId -> String
newsStoryPath newsId =
  "news/" ++ toString newsId

fetchLocationData : Route -> Model -> Cmd Msg
fetchLocationData location model =
  let
    baseCmds =
      [ fetchInfo model.config.apiUrl
      , fetchNewsList model.config.apiUrl
      , fetchSponsors model.config.apiUrl
      ]
  in
    case location of
      -- TODO: This should be handled in another way that actually caches
      -- the requests we've made already, but works when user arrives from direct url.
      Models.IndexRoute ->
        ( Cmd.batch baseCmds )
      Models.LoginRoute ->
        ( Cmd.batch baseCmds )
      Models.NewsListRoute ->
        ( Cmd.batch baseCmds )
      Models.NewsRoute newsId ->
        -- Check if we already have the news fetched
        if Dict.member newsId model.news then
          ( Cmd.batch baseCmds )
        else
          ( Cmd.batch ( fetchSingleNewsStory model.config.apiUrl newsId :: baseCmds ) )
      Models.NotFoundRoute ->
        ( Cmd.none )


matchers : Parser (Route -> a) a
matchers =
  oneOf
    [ map IndexRoute top
    , map NewsRoute (s "news" </> int)
    , map NewsListRoute (s "news")
    , map LoginRoute (s "login")
    ]


parseLocation : Location -> Route
parseLocation location =
  case (parsePath matchers location) of
    Just route ->
      route

    Nothing ->
      NotFoundRoute
