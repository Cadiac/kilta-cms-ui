module Components.News exposing (view)

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

newsItem : NewsItem -> Html Msg
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

-- CSS

type alias Style =
  List ( String, String )

styles : { heading : Style }
styles =
  {
    heading =
      [ ( "display", "flex" )
      , ( "justify-content", "space-around")
      ]
  }
