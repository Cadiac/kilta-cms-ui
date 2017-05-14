module Common.Logo exposing (view)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)

import RemoteData exposing (WebData)
import Models exposing (Info)

import Routing exposing (onLinkClick)

maybeLogo : WebData Info -> Html Msg
maybeLogo response =
  case response of
    RemoteData.NotAsked ->
      text ""

    RemoteData.Loading ->
      text "Loading..."

    RemoteData.Success info ->
      a [ href "/", onLinkClick (Msgs.ChangeLocation "/")] [
        img
          [ style styles.logo
          , src info.logo.url
          , alt info.name
          ] []
      ]

    RemoteData.Failure error ->
      text (toString error)

view : WebData Info -> Html Msg
view info =
  maybeLogo info

styles : { logo : List ( String, String ) }
styles =
  {
    logo =
      [ ( "position", "absolute" )
      , ( "left", "40px")
      , ( "top", "40px")
      , ( "z-index", "100")
      , ( "max-height", "150px")
      , ( "max-width", "150px")
      ]
  }
