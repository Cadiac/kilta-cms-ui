module User.ProfilePage exposing (view)

import Msgs exposing (Msg)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import RemoteData exposing (WebData)

import Models exposing (LoginForm, Model, Profile)

maybeProfileForm : WebData Profile -> Html Msg
maybeProfileForm response =
  case response of
    RemoteData.NotAsked ->
      text ""

    RemoteData.Loading ->
      text "Loading..."

    RemoteData.Success profile ->
      Html.form
        [ onSubmit Msgs.Login ]
        [ div []
          [ div []
            [ label
              [ for "username" ]
              [ text "Tunnus" ]
            , input
              [ onInput (Msgs.ProfileFormInput Models.FirstName)
              , value profile.username
              ]
              []
            ]
          , div
              [ class "form-group" ]
              [ label
                [ for "firstName" ]
                [ text "Etunimi" ]
              , input
                [ onInput (Msgs.ProfileFormInput Models.FirstName)
                , value profile.firstName
                ]
                []
              ]
          , div
              [ class "form-group" ]
              [ label
                [ for "lastName" ]
                [ text "Sukunimi" ]
              , input
                [ onInput (Msgs.ProfileFormInput Models.LastName)
                , value profile.lastName
                ]
                []
              ]
          , div
              [ class "form-group" ]
              [ label
                [ for "email" ]
                [ text "Sähköposti" ]
              , input
                [ onInput (Msgs.ProfileFormInput Models.Email)
                , value profile.email
                ]
                []
              ]
          , div
              [ class "form-group" ]
              [ label
                [ for "phone" ]
                [ text "Puhelin" ]
              , input
                [ onInput (Msgs.ProfileFormInput Models.Phone)
                , value profile.phone
                ]
                []
              ]
          , div
              [ class "form-group" ]
              [ label
                [ for "role" ]
                [ text "Rooli" ]
              , input
                [ onInput (Msgs.ProfileFormInput Models.FirstName)
                , value profile.role
                ]
                []
              ]
          , button
            [ type_ "submit" ]
            [ text "Tallenna" ]
          ]
        ]

    RemoteData.Failure error ->
      text (toString error)

view : Model -> Html Msg
view model =
  div [ class "box" ] [
    div [ class "heading" ] [
      h1 [ class "title is-3" ] [
        text "Profiili"
      ]
    ]
    , maybeProfileForm model.profile
  ]
