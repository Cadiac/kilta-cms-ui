module Common.Navbar exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)

import Msgs exposing (Msg)
import Models exposing (Info, General)
import RemoteData exposing (WebData)

import Utils exposing (onLinkClick)

maybeTitle : WebData (Info) -> Html Msg
maybeTitle info =
  case info of
    RemoteData.NotAsked ->
      text ""

    RemoteData.Loading ->
      a [ class "btn regular", href "/", onLinkClick (Msgs.ChangeLocation "/")] [
        text "Loading..."
      ]

    RemoteData.Success info ->
      a [ class "btn regular", href "/", onLinkClick (Msgs.ChangeLocation "/")] [
        text ( info.title )
      ]

    RemoteData.Failure error ->
      text (toString error)

view : General -> Html Msg
view data =
  header [ class "nav" ] [
    div [ class "nav-left" ] [
      div [ class "nav-item" ] [
        maybeTitle data.info
      ]
    ]
    , div [ class "nav-right nav-menu" ] [
      a [ class "button is-primary is-inverted", href "/login", onLinkClick (Msgs.ChangeLocation "/login") ] [
        span [ class "icon" ][
          i [ class "fa fa-github" ] []
        ],
        span [] [
          text ( "Login" )
        ]
      ]
    ]
  ]
