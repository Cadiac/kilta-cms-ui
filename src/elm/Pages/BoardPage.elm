module Pages.BoardPage exposing (view)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)

import RemoteData exposing (WebData)
import Dict exposing (Dict)
import Models exposing (BoardItem, BoardMember, Model, Slug)

import Pages.PagesMenu

import Markdown

boardMember : BoardMember -> Html Msg
boardMember member =
  figure [ class "column is-3" ] [
    img
      [ class "image is-96x96"
      , src member.image.url
      , alt member.title
      ] []
    , p [ class "title is-4" ] [
      text (member.first_name ++ " " ++ member.last_name)
    ]
    , p [ class "subtitle is-5" ] [
      text member.title
    ]
    , p [] [
      text ("Email: " ++ member.email)
    ]
    , p [] [
      text ("IRC: " ++ member.irc)
    ]
  ]

boardItem : BoardItem -> Html Msg
boardItem board =
  article [] [
    div [ class "heading" ] [
      h2 [ class "title is-3" ] [
        text board.meta.title
      ]
    ]
    , Markdown.toHtml [ class "content" ] board.meta.text
    , div [ class "columns is-multiline is-mobile" ] [
      boardMember board.chairman
    ]
    , p [ class "subtitle is-3" ] [
      text board.meta.board_members_title
    ]
    , div [ class "columns is-multiline is-mobile" ] (
      List.map boardMember board.board_members
    )
    , p [ class "subtitle is-3" ] [
      text board.meta.board_officials_title
    ]
    , div [ class "columns is-multiline is-mobile" ] (
      List.map boardMember board.board_officials
    )
  ]

maybePageContent : WebData (BoardItem) -> Html Msg
maybePageContent response =
  case response of
    RemoteData.NotAsked ->
      text ""

    RemoteData.Loading ->
      text "Loading..."

    RemoteData.Success board ->
      boardItem board

    RemoteData.Failure error ->
      text (toString error)

view : Model -> Slug -> Html Msg
view model year =
  section [ class "section" ] [
    div [ class "columns" ] [
      div [ class "column is-3" ] [
        Pages.PagesMenu.view model
      ],
      div [ class "column" ] [
        maybePageContent (
          Dict.get year model.boards
            |> Maybe.withDefault RemoteData.NotAsked
        )
      ]
    ]
  ]
