module Routing exposing (..)

import Html exposing (Attribute)
import Html.Events exposing (onWithOptions)

import Dict exposing (Dict)

import Navigation exposing ( Location, newUrl )
import Commands exposing (..)
import UrlParser exposing (..)
import Json.Decode as Decode
import RemoteData exposing (WebData)

import Msgs exposing (Msg)
import Models exposing ( NewsId, EventId, Model, Route(..), Info, Slug )

loginPath : String
loginPath =
  "/login"

profilePath : String
profilePath =
  "/profile"

newsPath : String
newsPath =
  "/news"

newsStoryPath : NewsId -> String
newsStoryPath newsId =
  "/news/" ++ toString newsId

eventsPath : String
eventsPath =
  "/events"

eventPath : EventId -> String
eventPath eventId =
  "/events/" ++ toString eventId

pagePath : Slug -> String
pagePath category =
  "/pages/" ++ category

subPagePath : Slug -> Slug -> String
subPagePath category slug =
  "/pages/" ++ category ++ "/" ++ slug

maybeRequestData : Cmd Msg -> WebData a -> Cmd Msg
maybeRequestData command data =
  case data of
    RemoteData.NotAsked ->
      command
    RemoteData.Failure error ->
      command

    RemoteData.Loading ->
      Cmd.none
    RemoteData.Success newsItem ->
      Cmd.none


fetchLocationData : Route -> Model -> Cmd Msg
fetchLocationData location model =
  let
    baseCmds =
      [ maybeRequestData (fetchInfo model.config.apiUrl) model.info
      , maybeRequestData (fetchFooter model.config.apiUrl) model.footer
      , maybeRequestData (fetchNewsList model.config.apiUrl) model.newsList
      , maybeRequestData (fetchEventsList model.config.apiUrl) model.eventsList
      , maybeRequestData (fetchSponsors model.config.apiUrl) model.sponsors
      , maybeRequestData (fetchNewsCategories model.config.apiUrl) model.newsCategories
      , maybeRequestData (fetchPageCategories model.config.apiUrl) model.pageCategories
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
        -- Check if we already have the event fetched
        if Dict.member eventId model.events then
          ( Cmd.batch baseCmds )
        else
          ( Cmd.batch ( fetchSingleEvent model.config.apiUrl eventId :: baseCmds ) )
      -- TODO: Add required commands
      Models.PageRoute category ->
        ( Cmd.batch baseCmds )
      Models.SubPageRoute category slug ->
        -- Check if we already have the event fetched
        if Dict.member slug model.pages then
          ( Cmd.batch baseCmds )
        else
          ( Cmd.batch ( fetchSinglePage model.config.apiUrl slug :: baseCmds ) )
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
    , map PageRoute (s "pages" </> string)
    , map SubPageRoute (s "pages" </> string </> string)
    ]


parseLocation : Location -> Route
parseLocation location =
  case (parsePath matchers location) of
    Just route ->
      route

    Nothing ->
      NotFoundRoute

locationSubtitle : Route -> String
locationSubtitle route =
  case route of
    IndexRoute ->
      "Etusivu"
    LoginRoute ->
      "Kirjaudu"
    ProfileRoute ->
      "Profiili"
    NewsListRoute ->
      "Uutiset"
    NewsRoute newsId ->
      "Uutiset"
    EventListRoute ->
      "Tapahtumat"
    EventRoute eventId ->
      "Tapahtumat"
    PageRoute category ->
      category
    SubPageRoute category slug ->
      slug
    NotFoundRoute ->
      "Sivua ei löytynyt"

locationTitle : Maybe Info -> Route -> String
locationTitle info route =
  let
    subTitle = locationSubtitle route
  in
    case info of
      Just info ->
        subTitle ++ " - " ++ info.title
      Nothing ->
        subTitle

onLinkClick : msg -> Attribute msg
onLinkClick message =
  let
    options =
      { stopPropagation = False
      , preventDefault = True
      }
  in
    onWithOptions "click" options (Decode.succeed message)
