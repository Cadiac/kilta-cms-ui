module User.LogoutPage exposing (view)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)

import Models exposing (PageItem, Model, Slug)

view : Model -> Html Msg
view model =
  section [ class "section" ] [
    h1 [ class "title" ] [
      text "Olet kirjautunut ulos"
    ],
    h2 [ class "subtitle" ] [
      text (
        "Sinut ohjataan takaisin etusivulle "
        ++ toString model.logoutTimer
        ++ " sekunnin päästä"
      )
    ]
  ]
