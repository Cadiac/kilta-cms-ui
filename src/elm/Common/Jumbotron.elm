module Common.Jumbotron exposing (view)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)

import Array
import RemoteData exposing (WebData)
import Models exposing (Info, Model)

maybeJumbotron : WebData (Info) -> Int -> Html Msg
maybeJumbotron response timer =
  case response of
    RemoteData.NotAsked ->
      text ""

    RemoteData.Loading ->
      text "Loading..."

    RemoteData.Success info ->
      let
        imagesArray =
          Array.fromList info.jumbotron
        imagesCount =
          Array.length imagesArray
        imageIndex =
          timer % imagesCount
        imageSrc =
          case (Array.get imageIndex imagesArray) of
            Just jumbotronImage ->
              jumbotronImage
            Nothing ->
              Models.JumbotronImage "placeholder" "https://placehold.it/1600x900"
      in
        img
          [ style styles.jumbotron
          , src imageSrc.url
          , alt imageSrc.title
          ] []

    RemoteData.Failure error ->
      text (toString error)

view : Model -> Html Msg
view model =
  maybeJumbotron model.info model.jumbotronTimer

styles : { jumbotron : List ( String, String ) }
styles =
  {
    jumbotron =
      [ ( "width", "100%" )
      , ( "max-height", "300px")
      , ( "object-fit", "cover")
      ]
  }
