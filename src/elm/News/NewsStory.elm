module News.NewsStory exposing (view)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)

import RemoteData exposing (WebData)
import Models exposing (NewsItem, NewsId, Model)
import News.Components

import Components.Sponsors

maybeNewsContent : WebData (List NewsItem) -> NewsId -> Html Msg
maybeNewsContent response newsId =
  case response of
    RemoteData.NotAsked ->
      text ""

    RemoteData.Loading ->
      text "Loading..."

    RemoteData.Success news ->
      let
        maybeNewsStory =
          news
            |> List.filter (\newsStory -> newsStory.id == newsId)
            |> List.head
      in
        case maybeNewsStory of
          Just newsStory ->
            section [ class "section" ] [
              News.Components.newsItem newsStory
            ]

          Nothing ->
            notFoundView

    RemoteData.Failure error ->
      text (toString error)

view : Model -> NewsId -> Html Msg
view model newsId =
  div [] [
    section [ class "section" ] [
      div [ class "columns" ] [
        div [ class "column is-two-thirds"] [
          maybeNewsContent model.news newsId
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
