module User.LoginForm exposing (view)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Models exposing (LoginForm, Model)

view : Model -> Html Msg
view model =
  div [ class "box" ] [
    div [ class "heading" ] [
      h1 [ class "title is-3" ] [
        text "Kirjaudu sisään"
      ]
    ]
    , div []
      [ Html.form
        [ onSubmit Msgs.Login ]
        [ div []
          [ div []
            [ label
              [ for "username" ]
              [ text "Tunnus" ]
            , input
              [ onInput (Msgs.LoginFormInput Models.Username)
              , value model.username
              ]
              []
            ]
          , div
              [ class "form-group" ]
              [ label
                [ for "password" ]
                [ text "Salasana" ]
              , input
                [ onInput (Msgs.LoginFormInput Models.Password)
                , value model.password
                ]
                []
              ]
          , button
            [ type_ "submit" ]
            [ text "Login" ]
          ]
        ]
      ]
    , div []
      [ p []
        [ text model.token ]
      ]
    ]
