module News.List exposing (view)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)

import RemoteData exposing (WebData)
import Models exposing (NewsItem)
import News.Components exposing (maybeNewsList)

view : WebData (List NewsItem) -> Html Msg
view response =
  section [ class "box" ] [
    div [ class "heading" ] [
      h1 [ class "title is-3" ] [
        text "Ajankohtaista"
      ]
    ]
    , hr [][]
    , maybeNewsList response
  ]
