module Routing exposing (..)

import Navigation exposing (Location)
import Models exposing (NewsId, Route(..))
import UrlParser exposing (..)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map IndexRoute top
        , map NewsRoute (s "news" </> string)
        , map NewsListRoute (s "news")
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
