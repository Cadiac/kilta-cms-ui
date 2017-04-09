module Components.Navbar exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)

import Msgs exposing (Msg)
import Models exposing (Info)
import RemoteData exposing (WebData)

maybeTitle : WebData (Info) -> Html Msg
maybeTitle response =
  case response of
    RemoteData.NotAsked ->
      text ""

    RemoteData.Loading ->
      text "Loading..."

    RemoteData.Success info ->
      text ( info.title )

    RemoteData.Failure error ->
      text (toString error)

view : WebData Info -> Html Msg
view response =
  header [ class "nav" ][
    div [ class "nav-left" ][
      div [ class "nav-item" ][
        maybeTitle response
      ]
    ]
    , div [ class "nav-right nav-menu" ][
      a [ class "button is-primary is-inverted" ][
        span [ class "icon" ][
          i [ class "fa fa-github" ][]
        ],
        span [][
          text ( "Login" )
        ]
      ]
    ]
  ]
