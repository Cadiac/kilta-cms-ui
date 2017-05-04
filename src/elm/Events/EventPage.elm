module Events.EventPage exposing (view)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
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
    ),
    case model.decodedToken of
      Just decoded ->
        div [ class "field" ] [
          p [ class "control" ] [
            button [ class "button is-primary", onClick (Msgs.ParticipateEvent eventId)] [
              text "Osallistu"
            ]
          ]
        ]
      Nothing ->
        div [ class "field" ] [
          p [ class "control" ] [
            button [ class "button is-primary", disabled True ] [
              text "Osallistu"
            ]
          ]
        ]
  ]

notFoundView : Html msg
notFoundView =
  section [ class "section" ] [
    text "Tapahtumaa ei löytynyt"
  ]
