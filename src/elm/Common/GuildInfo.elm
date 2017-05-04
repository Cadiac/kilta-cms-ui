module Common.GuildInfo exposing (view)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)

import RemoteData exposing (WebData)
import Models exposing (Info)

import Markdown

maybeGuildInfo : WebData (Info) -> Html Msg
maybeGuildInfo response =
  case response of
    RemoteData.NotAsked ->
      text ""

    RemoteData.Loading ->
      text "Loading..."

    RemoteData.Success info ->
      Markdown.toHtml [ class "content" ] info.introduction

    RemoteData.Failure error ->
      text (toString error)

view : WebData (Info) -> Html Msg
view response =
  section [ class "section" ] [
    div [ class "columns" ] [
      div [ class "column" ] [
        maybeGuildInfo response
      ]
    ]
  ]
