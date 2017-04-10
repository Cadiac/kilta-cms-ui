module News.NewsStory exposing (view)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)

import RemoteData exposing (WebData)
import Models exposing (NewsItem, Model)
import News.Components exposing (newsItem)

import Components.Navbar
import Components.Sponsors

maybeNewsContent : WebData (List NewsItem) -> Html Msg
maybeNewsContent response =
  case response of
    RemoteData.NotAsked ->
      text ""

    RemoteData.Loading ->
      text "Loading..."

    RemoteData.Success newsStory ->
      section [ class "box" ] [
        newsItem newsStory
      ]

    RemoteData.Failure error ->
      text (toString error)

view : Model -> Html Msg
view model =
  div [] [
    Components.Navbar.view model.info
    , section [ class "section" ] [
      div [ class "columns" ] [
        div [ class "column is-two-thirds"] [
          maybeNewsContent model.news
        ]
        , div [ class "column" ] [
          Components.Sponsors.view model.sponsors
        ]
      ]
    ]
  ]
