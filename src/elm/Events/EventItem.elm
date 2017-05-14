module Events.EventItem exposing (view)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)

import Models exposing (EventItem)
import Routing exposing (eventPath, onLinkClick)

import Markdown

participantRow : Int -> String -> Html Msg
participantRow index participant =
  tr [] [
    th [] [ text (toString index) ],
    td [] [ text participant ]
  ]

view : EventItem -> Html Msg
view event =
  let
    path =
      eventPath event.id
  in
    article [ class "section" ] [
      div [ class "heading" ] [
        a [ class "btn regular", href path, onLinkClick (Msgs.ChangeLocation path)] [
          h1 [ class "title" ] [
            text event.title
          ]
        ]
        , hr [][]
      ]
      , Markdown.toHtml [ class "content" ] event.text
      , table [ class "table" ] [
        tbody [] [
          tr [] [
            th [] [ text "Missä:" ],
            td [] [ text event.location ]
          ],
          tr [] [
            th [] [ text "Alku:" ],
            td [] [ text event.event_start_time ]
          ],
          tr [] [
            th [] [ text "Loppu:" ],
            td [] [ text event.event_end_time ]
          ],
          tr [] [
            th [] [ text "Ilmottautuminen alkaa:" ],
            td [] [ text event.registration_start_time ]
          ],
          tr [] [
            th [] [ text "Ilmottautuminen päättyy:" ],
            td [] [ text event.registration_end_time ]
          ],
          tr [] [
            th [] [ text "Osallistujia:" ],
            td [] [
              text (
                (List.length event.participants |> toString) ++
                "/" ++
                (toString event.max_participants)
              )
            ]
          ]
        ]
      ]
      , h2 [ class "subtitle" ] [ text "Osallistujat" ]
      , table [ class "table" ] [
        thead [] [
          tr [] [
            th [] [ text "#" ],
            th [] [ text "Nimi" ]
          ]
        ],
        tbody [] (
          List.indexedMap participantRow event.participants
        )
      ]
      , hr [][]
      , p [] [
        text ("Julkaistu " ++ event.created_on)
      ]
      , p [] [
        text ("Kirjoittajat: " ++ (String.join ", " event.authors))
      ]
    ]
