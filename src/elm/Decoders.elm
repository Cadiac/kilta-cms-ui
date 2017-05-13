module Decoders exposing (..)

import Json.Decode as Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional, requiredAt, hardcoded)

import Jwt exposing (decodeToken)

import Models exposing (..)

sponsorsDecoder : Decoder (List Sponsor)
sponsorsDecoder =
  list sponsorDecoder

sponsorDecoder : Decoder Sponsor
sponsorDecoder =
  decode Sponsor
    |> required "name" string
    |> required "website" string
    |> requiredAt ["logo", "url"] string

newsCategoriesDecoder : Decoder (List NewsCategory)
newsCategoriesDecoder =
  list newsCategoryDecoder

newsCategoryDecoder : Decoder NewsCategory
newsCategoryDecoder =
  decode NewsCategory
    |> required "id" int
    |> required "title" string
    |> required "slug" string

pageCategoriesDecoder : Decoder (List PageCategory)
pageCategoriesDecoder =
  list pageCategoryDecoder

pageCategoryDecoder : Decoder PageCategory
pageCategoryDecoder =
  decode PageCategory
    |> required "title" string
    |> required "slug" string
    |> required "subpages" (list subpageCategoryDecoder)

subpageCategoryDecoder : Decoder SubPage
subpageCategoryDecoder =
  decode SubPage
    |> required "title" string
    |> required "slug" string
    |> optional "priority" int 1

infoDecoder : Decoder Info
infoDecoder =
  decode Info
    |> required "main_title" string
    |> required "introduction_text" string
    |> required "guild_name" string
    |> required "guild_logo" imageDecoder
    |> required "jumbotron_images" (list jumbotronDecoder)

imageDecoder : Decoder Image
imageDecoder =
  decode Image
    |> required "url" string
    |> required "thumbnail" string

jumbotronDecoder : Decoder JumbotronImage
jumbotronDecoder =
  decode JumbotronImage
    |> required "title" string
    |> required "url" string

footerLinkDecoder : Decoder FooterLink
footerLinkDecoder =
  decode FooterLink
    |> required "title" string
    |> required "link" string

socialMediaButtonDecoder : Decoder SocialMediaButton
socialMediaButtonDecoder =
  decode SocialMediaButton
    |> required "name" string
    |> required "link" string
    |> required "logo" imageDecoder

footerDecoder : Decoder Footer
footerDecoder =
  decode Footer
    |> required "contact_info" string
    |> required "other_links" (list footerLinkDecoder)
    |> required "social_media_buttons" (list socialMediaButtonDecoder)

newsDecoder : Decoder (List NewsItem)
newsDecoder =
  list newsItemDecoder

newsItemDecoder : Decoder NewsItem
newsItemDecoder =
  decode NewsItem
    |> required "id" int
    |> required "title" string
    |> required "text" string
    |> required "slug" string
    |> required "created_on" string
    |> required "tags" string
    |> required "news_category" int
    |> required "authors" (list string)

eventsDecoder : Decoder (List EventItem)
eventsDecoder =
  list eventItemDecoder

eventItemDecoder : Decoder EventItem
eventItemDecoder =
  decode EventItem
    |> required "id" int
    |> required "title" string
    |> required "text" string
    |> required "slug" string
    |> required "created_on" string
    |> required "location" string
    |> required "event_start_time" string
    |> required "event_end_time" string
    |> required "registration_start_time" string
    |> required "registration_end_date" string
    |> required "max_participants" int
    |> required "authors" (list string)
    |> required "participants" (list string)

tokenStringDecoder : Decoder String
tokenStringDecoder =
  field "token" string

tokenDecoder : Decoder JwtToken
tokenDecoder =
  decode JwtToken
    |> required "id" int
    |> required "role" string
    |> required "username" string
    |> required "iat" int
    |> required "exp" int

maybeDecodeToken : String -> Maybe JwtToken
maybeDecodeToken tokenString =
  Result.toMaybe (decodeToken tokenDecoder tokenString)

profileDecoder : Decoder Profile
profileDecoder =
  decode Profile
    |> required "username" string
    |> required "first_name" string
    |> required "last_name" string
    |> required "email" string
    |> required "phone" string
    |> required "role" string

pageDecoder : Decoder PageItem
pageDecoder =
  decode PageItem
    |> required "title" string
    |> required "slug" string
    |> required "text" string
    |> required "category_id" int

boardMetaDecoder : Decoder BoardMeta
boardMetaDecoder =
  decode BoardMeta
    |> required "text" string
    |> required "title" string
    |> required "year" int
    |> required "slug" string
    |> required "board_members_title" string
    |> required "board_officials_title" string

boardMemberDecoder : Decoder BoardMember
boardMemberDecoder =
  decode BoardMember
    |> required "id" int
    |> required "title" string
    |> required "first_name" string
    |> required "last_name" string
    |> required "email_shorthand" string
    |> required "IRC_nick" string
    |> required "image" imageDecoder

boardDecoder : Decoder BoardItem
boardDecoder =
  decode BoardItem
    |> required "meta" boardMetaDecoder
    |> required "chairman" boardMemberDecoder
    |> required "board_members" (list boardMemberDecoder)
    |> required "board_officials" (list boardMemberDecoder)
