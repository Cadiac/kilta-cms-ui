module Routing exposing (..)

import Html exposing (Attribute)
import Html.Events exposing (onWithOptions)

import Dict exposing (Dict)

import Navigation exposing ( Location, newUrl )
import Commands exposing (..)
import UrlParser exposing (..)
import Json.Decode as Decode

import Msgs exposing (Msg)
import Models exposing ( NewsId, EventId, Model, Route(..) )

loginPath : String
loginPath =
  "login"

profilePath : String
profilePath =
  "profile"

newsPath : String
newsPath =
  "news"

newsStoryPath : NewsId -> String
newsStoryPath newsId =
  "news/" ++ toString newsId

eventsPath : String
eventsPath =
  "events"

eventPath : EventId -> String
eventPath eventId =
  "events/" ++ toString eventId

fetchLocationData : Route -> Model -> Cmd Msg
fetchLocationData location model =
  let
    baseCmds =
      [ fetchInfo model.config.apiUrl
      , fetchFooter model.config.apiUrl
      , fetchNewsList model.config.apiUrl
      , fetchEventsList model.config.apiUrl
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
      Models.ProfileRoute ->
        ( Cmd.batch ( fetchProfile model.config.apiUrl model.token :: baseCmds ) )
      Models.NewsListRoute ->
        ( Cmd.batch baseCmds )
      Models.NewsRoute newsId ->
        -- Check if we already have the news fetched
        if Dict.member newsId model.news then
          ( Cmd.batch baseCmds )
        else
          ( Cmd.batch ( fetchSingleNewsStory model.config.apiUrl newsId :: baseCmds ) )
      Models.EventListRoute ->
        ( Cmd.batch baseCmds )
      Models.EventRoute eventId ->
        -- Check if we already have the news fetched
        if Dict.member eventId model.events then
          ( Cmd.batch baseCmds )
        else
          ( Cmd.batch ( fetchSingleEvent model.config.apiUrl eventId :: baseCmds ) )
      Models.NotFoundRoute ->
        ( Cmd.none )


matchers : Parser (Route -> a) a
matchers =
  oneOf
    [ map IndexRoute top
    , map NewsListRoute (s "news")
    , map NewsRoute (s "news" </> int)
    , map EventListRoute (s "events")
    , map EventRoute (s "events" </> int)
    , map LoginRoute (s "login")
    , map ProfileRoute (s "profile")
    ]


parseLocation : Location -> Route
parseLocation location =
  case (parsePath matchers location) of
    Just route ->
      route

    Nothing ->
      NotFoundRoute


onLinkClick : msg -> Attribute msg
onLinkClick message =
  let
    options =
      { stopPropagation = False
      , preventDefault = True
      }
  in
    onWithOptions "click" options (Decode.succeed message)
