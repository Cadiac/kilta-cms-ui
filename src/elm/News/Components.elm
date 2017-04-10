module News.Components exposing (maybeNewsList, newsItem)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)

import RemoteData exposing (WebData)
import Models exposing (NewsItem)

maybeNewsList : WebData (List NewsItem) -> Html Msg
maybeNewsList response =
  case response of
    RemoteData.NotAsked ->
      text ""

    RemoteData.Loading ->
      text "Loading..."

    RemoteData.Success news ->
      div [] (
        List.map newsItem news
      )

    RemoteData.Failure error ->
      text (toString error)

newsItem : NewsItem -> Html msg
newsItem news =
  article [] [
    div [ class "heading" ] [
      h2 [ class "subtitle is-4" ] [
        text news.title
      ]
    ]
    , div [ class "content" ] [
      text news.text
    ]
  ]