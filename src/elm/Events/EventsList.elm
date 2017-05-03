module Events.EventsList exposing (view)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)

import RemoteData exposing (WebData)
import Models exposing (EventItem)
import RemoteData exposing (WebData)

import Events.EventItem

maybeEventsList : WebData (List EventItem) -> Html Msg
maybeEventsList response =
  case response of
    RemoteData.NotAsked ->
      text ""

    RemoteData.Loading ->
      text "Loading..."

    RemoteData.Success eventItem ->
      div [] (
        List.map Events.EventItem.view eventItem
      )

    RemoteData.Failure error ->
      text (toString error)

view : WebData (List EventItem) -> Html Msg
view response =
  section [ class "box" ] [
    div [ class "heading" ] [
      h1 [ class "title is-3" ] [
        text "Tapahtumat"
      ]
    ]
    , maybeEventsList response
  ]
