module Events.EventItem exposing (view)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)

import Models exposing (EventItem)
import Routing exposing (eventPath, onLinkClick)

import Markdown

view : EventItem -> Html Msg
view event =
  let
    path =
      eventPath event.id
  in
    article [] [
      hr [][],
      div [ class "heading" ] [
        a [ class "btn regular", href path, onLinkClick (Msgs.ChangeLocation path)] [
          h2 [ class "subtitle is-4" ] [
            text event.title
          ]
        ]
      ]
      , Markdown.toHtml [ class "content" ] event.text
    ]
