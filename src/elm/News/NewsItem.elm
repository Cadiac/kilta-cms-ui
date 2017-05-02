module News.NewsItem exposing (view)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)

import Models exposing (NewsItem)
import Routing exposing (newsStoryPath)

import Routing exposing (onLinkClick)

view : NewsItem -> Html Msg
view news =
  let
    path =
      newsStoryPath news.id
  in
    article [] [
      div [ class "heading" ] [
        a [ class "btn regular", href path, onLinkClick (Msgs.ChangeLocation path)] [
          h2 [ class "subtitle is-4" ] [
            text news.title
          ]
        ]
      ]
      , div [ class "content" ] [
        text news.text
      ]
    ]
