module Events.EventPage exposing (view)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)
import Dict exposing (Dict)

import RemoteData exposing (WebData)
import Models exposing (EventItem, EventId, Model)
import Events.EventItem

maybeEventContent : WebData (EventItem) -> Html Msg
maybeEventContent response =
  case response of
    RemoteData.NotAsked ->
      text ""

    RemoteData.Loading ->
      text "Loading..."

    RemoteData.Success event ->
      section [ class "section" ] [
        Events.EventItem.view event
      ]

    RemoteData.Failure error ->
      text (toString error)

view : Model -> EventId -> Html Msg
view model eventId =
  div [] [
    maybeEventContent (
      Dict.get eventId model.events
        |> Maybe.withDefault RemoteData.NotAsked
    )
  ]

notFoundView : Html msg
notFoundView =
  section [ class "section" ] [
    text "Tapahtumaa ei löytynyt"
  ]
