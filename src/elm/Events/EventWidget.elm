module Events.EventWidget exposing (upcomingView, pastView)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)

import Date exposing (Date)

import RemoteData exposing (WebData)
import Models exposing (EventItem, Model)

import Routing exposing (eventPath, onLinkClick)

shortDate : String -> String
shortDate dateString =
  let
    dateResult =
      Date.fromString dateString
    date =
      case dateResult of
        Ok parsed ->
          parsed
        Err error ->
          -- Date couldn't be parsed
          Date.fromTime 0
  in
    -- TODO: get month as int
    (Date.day date |> toString) ++ "." ++ (Date.month date |> toString) ++ "."

maybeEventsList : WebData (List EventItem) -> Html Msg
maybeEventsList response =
  case response of
    RemoteData.NotAsked ->
      text ""

    RemoteData.Loading ->
      text "Loading..."

    RemoteData.Success events ->
      table [ class "table is-striped" ] [
        tbody [] (
          List.map eventItem events
        )
      ]

    RemoteData.Failure error ->
      text (toString error)

eventItem : EventItem -> Html Msg
eventItem event =
  let
    path =
      eventPath event.id
  in
    tr [] [
      th [] [
        shortDate event.event_start_time
        ++ " - "
        ++ shortDate event.event_end_time
        |> text
      ]
      , td [] [
        a [ href path, onLinkClick (Msgs.ChangeLocation path) ] [
          text event.title
        ]
      ]
    ]

upcomingView : Model -> Html Msg
upcomingView model =
  div [ class "section" ] [
    div [ class "heading" ] [
      h1 [ class "subtitle", style styles.heading ] [
        text "Tulevat tapahtumat"
      ]
    ]
    , maybeEventsList model.upcomingEvents
  ]

pastView : Model -> Html Msg
pastView model =
  div [ class "section" ] [
    div [ class "heading" ] [
      h1 [ class "subtitle", style styles.heading ] [
        text "Menneet tapahtumat"
      ]
    ]
    , maybeEventsList model.pastEvents
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
