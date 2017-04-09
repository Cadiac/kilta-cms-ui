module Components.Sponsors exposing (view)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)

import RemoteData exposing (WebData)
import Models exposing (Sponsor)

maybeSponsorGrid : WebData (List Sponsor) -> Html Msg
maybeSponsorGrid response =
  case response of
    RemoteData.NotAsked ->
      text ""

    RemoteData.Loading ->
      text "Loading..."

    RemoteData.Success sponsors ->
      div [ class "columns is-multiline is-mobile" ] (
        List.map sponsorItem sponsors
      )

    RemoteData.Failure error ->
      text (toString error)

sponsorItem : Sponsor -> Html Msg
sponsorItem sponsor =
  div [ class "column is-one-third", style styles.column ] [
    figure [ class "image is-64x64", style styles.logo ][
      a [ href sponsor.website ][
        img [ alt sponsor.name, src sponsor.logo ][]
      ]
    ]
  ]

view : WebData (List Sponsor) -> Html Msg
view response =
  div [ class "box" ] [
    div [ class "heading" ] [
      h1 [ class "subtitle", style styles.heading ] [
        text "Yhteistyökumppanit"
      ]
    ]
    , maybeSponsorGrid response
  ]

-- CSS

type alias Style =
  List ( String, String )

styles : { heading : Style, column : Style, logo : Style }
styles =
  {
    heading =
      [ ( "display", "flex" )
      , ( "justify-content", "space-around")
      ],
    column =
      [ ( "display", "flex" )
      , ( "justify-content", "space-around")
      ],
    logo =
      [ ( "display", "flex" )
      , ( "align-items", "center")
      ]
  }
