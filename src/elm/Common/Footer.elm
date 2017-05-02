module Common.Footer exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)

import Msgs exposing (Msg)
import Models exposing (Footer, SocialMediaButton, FooterLink, Model)
import RemoteData exposing (WebData)

import Routing exposing (onLinkClick)

socialMediaButton : SocialMediaButton -> Html Msg
socialMediaButton button =
  div [ class "level" ]
  [ div [ class "level-left" ]
    [ a [ class "level-item", href button.url ]
      [ img
        [ class "image is-32x32 level-left"
        , src button.logo.thumbnail
        , alt button.title
        ] []
      , text button.title
      ]
    ]
  ]

otherLink : FooterLink -> Html Msg
otherLink footerLink =
  div [ class "level" ]
  [ div [ class "level-left" ]
    [ a [ class "level-item", href footerLink.url ]
      [ text footerLink.title ]
    ]
  ]


maybeFooterContent : WebData (Footer) -> Html Msg
maybeFooterContent response =
  case response of
    RemoteData.NotAsked ->
      text ""

    RemoteData.Loading ->
      a [ class "btn regular", href "/", onLinkClick (Msgs.ChangeLocation "/")] [
        text "Loading..."
      ]

    RemoteData.Success footer ->
      div [ class "columns" ]
        [ div [ class "column is-5" ] [
            text footer.contact_info
          ]
        , div [ class "column is-4" ] [
            div [ class "social" ] (
              List.map socialMediaButton footer.social_media_buttons
            )
          ]
        , div [ class "column is-3" ] [
            div [ class "other" ] (
              List.map otherLink footer.other_links
            )
        ]
      ]

    RemoteData.Failure error ->
      text (toString error)


view : Model -> Html Msg
view model =
  footer [ class "footer", style styles.footer ] [
    maybeFooterContent model.footer
  ]

-- CSS STYLES

styles : { footer : List ( String, String ) }
styles =
  {
    footer =
      [ ( "position", "absolute" )
      , ( "bottom", "0")
      , ( "right", "0")
      , ( "left", "0")
      ]
  }
