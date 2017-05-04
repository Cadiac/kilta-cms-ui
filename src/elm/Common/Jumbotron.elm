module Common.Jumbotron exposing (view)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)

import Array
import RemoteData exposing (WebData)
import Models exposing (Info)

maybeJumbotron : WebData (Info) -> Html Msg
maybeJumbotron response =
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
        imageSrc =
          case (Array.get 0 imagesArray) of
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

view : WebData (Info) -> Html Msg
view response =
  maybeJumbotron response

styles : { jumbotron : List ( String, String ) }
styles =
  {
    jumbotron =
      [ ( "width", "100%" )
      , ( "max-height", "300px")
      , ( "object-fit", "cover")
      ]
  }
