module News.NewsStory exposing (view)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)
import Dict exposing (Dict)

import RemoteData exposing (WebData)
import Models exposing (NewsItem, NewsId, Model)
import News.Components

import Components.Sponsors

maybeNewsContent : WebData (NewsItem) -> Html Msg
maybeNewsContent response =
  case response of
    RemoteData.NotAsked ->
      text ""

    RemoteData.Loading ->
      text "Loading..."

    RemoteData.Success newsStory ->
      section [ class "section" ] [
        News.Components.newsItem newsStory
      ]

    RemoteData.Failure error ->
      text (toString error)

view : Model -> NewsId -> Html Msg
view model newsId =
  div [] [
    section [ class "section" ] [
      div [ class "columns" ] [
        div [ class "column is-two-thirds"] [
          maybeNewsContent (
            Dict.get newsId model.news
              |> Maybe.withDefault RemoteData.NotAsked
          )
        ]
        , div [ class "column" ] [
          Components.Sponsors.view model.sponsors
        ]
      ]
    ]
  ]

notFoundView : Html msg
notFoundView =
  section [ class "section" ] [
    text "Not found"
  ]
