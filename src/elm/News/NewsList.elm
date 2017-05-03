module News.NewsList exposing (view)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)

import Models exposing (NewsItem)
import RemoteData exposing (WebData)

import News.NewsItem

maybeNewsList : WebData (List NewsItem) -> Html Msg
maybeNewsList response =
  case response of
    RemoteData.NotAsked ->
      text ""

    RemoteData.Loading ->
      text "Loading..."

    RemoteData.Success newsItem ->
      div [] (
        List.map News.NewsItem.view newsItem
      )

    RemoteData.Failure error ->
      text (toString error)

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
