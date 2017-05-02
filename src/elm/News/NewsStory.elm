module News.NewsStory exposing (view)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)
import Dict exposing (Dict)

import RemoteData exposing (WebData)
import Models exposing (NewsItem, NewsId, Model)
import News.NewsItem

maybeNewsContent : WebData (NewsItem) -> Html Msg
maybeNewsContent response =
  case response of
    RemoteData.NotAsked ->
      text ""

    RemoteData.Loading ->
      text "Loading..."

    RemoteData.Success newsStory ->
      section [ class "section" ] [
        News.NewsItem.view newsStory
      ]

    RemoteData.Failure error ->
      text (toString error)

view : Model -> NewsId -> Html Msg
view model newsId =
  div [] [
    maybeNewsContent (
      Dict.get newsId model.news
        |> Maybe.withDefault RemoteData.NotAsked
    )
  ]

notFoundView : Html msg
notFoundView =
  section [ class "section" ] [
    text "Not found"
  ]
