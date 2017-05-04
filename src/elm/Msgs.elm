module Msgs exposing (..)

import Navigation exposing (Location)
import RemoteData exposing (WebData)
import Models exposing (..)
import Http

type Msg
  = NoOp
  | Login
  | Logout
  | Auth (Result Http.Error String)
  | LoginFormInput LoginForm String
  | ProfileFormInput ProfileForm String
  | ChangeLocation String
  | OnLocationChange Location
  | OnFetchProfile (WebData Profile)
  | OnFetchSponsors (WebData (List Sponsor))
  | OnFetchInfo (WebData Info)
  | OnFetchFooter (WebData Footer)
  | OnFetchNewsList (WebData (List NewsItem))
  | OnFetchSingleNewsStory NewsId (WebData NewsItem)
  | OnFetchEventsList (WebData (List EventItem))
  | OnFetchSingleEvent EventId (WebData EventItem)
  | OnFetchNewsCategories (WebData (List NewsCategory))
  | OnFetchPageCategories (WebData (List PageCategory))
  | OnFetchSinglePage Slug (WebData PageItem)
