module Routing exposing (..)

import Html exposing (Attribute)
import Html.Events exposing (onWithOptions)

import Dict exposing (Dict)
import Char

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
  "/" ++ category

subPagePath : Slug -> Slug -> String
subPagePath category slug =
  "/" ++ category ++ "/" ++ slug

boardPagePath : Slug -> Slug -> String
boardPagePath category year =
  "/" ++ category ++ "/boards/" ++ year

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
      , maybeRequestData (fetchUpcomingEvents model.config.apiUrl) model.upcomingEvents
      , maybeRequestData (fetchPastEvents model.config.apiUrl) model.pastEvents 
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
      Models.LogoutRoute ->
        ( Cmd.batch baseCmds )
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
        if Dict.member eventId model.events then
          ( Cmd.batch baseCmds )
        else
          ( Cmd.batch ( fetchSingleEvent model.config.apiUrl eventId :: baseCmds ) )
      Models.PageRoute category ->
        let
          slug =
            defaultCategoryPageSlug model category
        in
          if Dict.member slug model.pages then
            ( Cmd.batch baseCmds )
          else
            ( Cmd.batch ( fetchSinglePage model.config.apiUrl slug :: baseCmds ) )

      Models.SubPageRoute category slug ->
        if Dict.member slug model.pages then
          ( Cmd.batch baseCmds )
        else
          ( Cmd.batch ( fetchSinglePage model.config.apiUrl slug :: baseCmds ) )
      Models.BoardRoute category year ->
        if Dict.member year model.boards then
          ( Cmd.batch baseCmds )
        else
          ( Cmd.batch ( fetchBoard model.config.apiUrl year :: baseCmds ) )
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
    , map LogoutRoute (s "logout")
    , map PageRoute (string)
    , map SubPageRoute (string </> string)
    , map BoardRoute (string </> s "boards" </> string)
    ]


parseLocation : Location -> Route
parseLocation location =
  case (parsePath matchers location) of
    Just route ->
      route

    Nothing ->
      NotFoundRoute

capitalize : String -> String
capitalize string =
  case String.uncons string of
    Nothing -> ""
    Just (head, tail) ->
      String.append (String.fromChar (Char.toUpper head)) tail

locationSubtitle : Route -> String
locationSubtitle route =
  case route of
    IndexRoute ->
      "Etusivu"
    LoginRoute ->
      "Kirjaudu"
    ProfileRoute ->
      "Profiili"
    LogoutRoute ->
      "Kirjaudu ulos"
    NewsListRoute ->
      "Uutiset"
    NewsRoute newsId ->
      "Uutiset"
    EventListRoute ->
      "Tapahtumat"
    EventRoute eventId ->
      "Tapahtumat"
    PageRoute category ->
      capitalize category
    SubPageRoute category slug ->
      capitalize category
    BoardRoute category year ->
      "Hallitus " ++ year
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

-- Converts relative url to Location
urlToLocation : String -> Location
urlToLocation url =
  { href = ""
  , host = ""
  , hostname = ""
  , protocol = ""
  , origin = ""
  , port_ = ""
  , pathname = url
  , search = ""
  , hash = ""
  , username = ""
  , password = ""
  }

isActivePage : Location -> Route -> Bool
isActivePage location route =
  let urlRoute
    = parseLocation location
  in
    urlRoute == route

defaultCategoryPageSlug : Model -> Slug -> Slug
defaultCategoryPageSlug model category =
  let
    maybeCategories =
      RemoteData.toMaybe model.pageCategories
  in
    case maybeCategories of
      Just categories ->
        let
          subpage =
            List.filter (\c -> c.slug == category) categories
              |> List.map (\c -> c.subpages)
              |> List.head
              |> Maybe.withDefault []
              |> List.head
        in
          case subpage of
            Just subpage ->
              subpage.slug
            Nothing ->
              ""
      Nothing ->
        ""

onLinkClick : msg -> Attribute msg
onLinkClick message =
  let
    options =
      { stopPropagation = False
      , preventDefault = True
      }
  in
    onWithOptions "click" options (Decode.succeed message)
