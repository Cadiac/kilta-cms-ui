module News.NewsItem exposing (view)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)

import Models exposing (NewsItem)
import Routing exposing (newsStoryPath, onLinkClick)

import Markdown

view : NewsItem -> Html Msg
view news =
  let
    path =
      newsStoryPath news.id
  in
    article [ class "section" ] [
      div [ class "heading" ] [
        a [ class "btn regular", href path, onLinkClick (Msgs.ChangeLocation path)] [
          h1 [ class "title" ] [
            text news.title
          ]
        ]
        , hr [][]
      ]
      , Markdown.toHtml [ class "content" ] news.text
      , hr [][]
      , p [ class "subtitle is-6" ] [
        text ("Julkaistu " ++ news.created_on)
      ]
      , p [ class "subtitle is-6" ] [
        text ("Kirjoittajat: " ++ (String.join ", " news.authors))
      ]
    ]
