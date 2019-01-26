module Toppokki where

import Prelude

import Control.Promise (Promise)
import Control.Promise as Promise
import Data.Function.Uncurried as FU
import Data.Newtype (class Newtype)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Exception (Error)
import Effect.Uncurried as EU
import Foreign (Foreign)
import Node.Buffer (Buffer)
import Prim.Row as Row
import Unsafe.Coerce (unsafeCoerce)

foreign import data Puppeteer :: Type
foreign import data Browser :: Type
foreign import data Page :: Type
foreign import data Frame :: Type
foreign import data ElementHandle :: Type
foreign import data ResponseListener :: Type
foreign import data Response :: Type
foreign import data Request :: Type
-- foreign import data Cookie :: Type
type Cookie = { name :: String, value :: String }

newtype URL = URL String
derive instance newtypeURL :: Newtype URL _

newtype Selector = Selector String
derive instance newtypeSelector :: Newtype Selector _

type LaunchOptions = ( headless :: Boolean, userDataDir :: String )

launch
  :: forall options trash
   . Row.Union options trash LaunchOptions
  => { | options }
  -> Aff Browser
launch = runPromiseAffE1 _launch

newPage :: Browser -> Aff Page
newPage = runPromiseAffE1 _newPage

goto :: URL -> Page -> Aff Unit
goto = runPromiseAffE2 _goto

close :: Browser -> Aff Unit
close = runPromiseAffE1 _close

content :: Page -> Aff String
content = runPromiseAffE1 _content

type ScreenshotOptions =
  ( path :: String
  , type :: String
  , quality :: Int
  , fullPage :: Boolean
  , clip ::
      { x :: Int
      , y :: Int
      , width :: Int
      , height :: Int
      }
  , omitBackground :: Boolean
  )

screenshot
  :: forall options trash
   . Row.Union options trash ScreenshotOptions
  => { | options }
  -> Page
  -> Aff Buffer
screenshot o p = runPromiseAffE2 _screenshot o p

foreign import data PDFMargin :: Type

type PDFMarginOptions =
  ( top :: String
  , right :: String
  , bottom :: String
  , left :: String
  )

makePDFMargin
  :: forall options trash
   . Row.Union options trash PDFMarginOptions
  => { | options }
  -> PDFMargin
makePDFMargin = unsafeCoerce

type PDFOptions =
  ( path :: String
  , scale :: Int
  , displayHeaderFooter :: Boolean
  , headerTemplate :: String
  , footerTemplate :: String
  , printBackground :: Boolean
  , landscape :: Boolean
  , pageRanges :: String
  , format :: String
  , width :: String
  , height :: String
  , margin :: PDFMargin
  )

pdf
  :: forall options trash
   . Row.Union options trash PDFOptions
  => { | options }
  -> Page
  -> Aff Buffer
pdf = runPromiseAffE2 _pdf

onPageError :: EU.EffectFn1 Error Unit -> Page -> Effect Unit
onPageError = EU.runEffectFn3 _on "pageerror"

onLoad :: EU.EffectFn1 Unit Unit -> Page -> Effect Unit
onLoad = EU.runEffectFn3 _on "load"

pageWaitForSelector
  :: forall options trash
   . Row.Union options trash
       ( visible :: Boolean
       , hidden :: Boolean
       , timeout :: Int
       )
  => Selector
  -> { | options }
  -> Page
  -> Aff ElementHandle
pageWaitForSelector = runPromiseAffE3 _pageWaitForSelector

focus :: Selector -> Page -> Aff Unit
focus = runPromiseAffE2 _focus

type_
  :: forall options trash
   . Row.Union options trash
       ( delay :: Int
       )
  => Selector
  -> String
  -> { | options }
  -> Page
  -> Aff Unit
type_ = runPromiseAffE4 _type

click :: Selector -> Page -> Aff Unit
click = runPromiseAffE2 _click

clickElement :: ElementHandle -> Aff Unit
clickElement = runPromiseAffE1 _clickElement

foreign import data WaitUntilOption :: Type

networkIdle :: WaitUntilOption
networkIdle = unsafeCoerce $ "networkidle"

waitForNavigation
  :: forall options trash
   . Row.Union options trash
       ( waitUntil :: WaitUntilOption
       )
  => { | options }
  -> Page
  -> Aff Unit
waitForNavigation = runPromiseAffE2 _waitForNavigation

getLocationRef :: Page -> Aff String
getLocationRef p = Promise.toAffE $ FU.runFn1 _getLocationHref p

unsafeEvaluateStringFunction :: String -> Page -> Aff Foreign
unsafeEvaluateStringFunction = runPromiseAffE2 _unsafeEvaluateStringFunction

setUserAgent :: String -> Page -> Aff Unit
setUserAgent = runPromiseAffE2 _setUserAgent

allowDownloads :: String -> Page -> Aff Unit
allowDownloads = runPromiseAffE2 _allowDownloads

setViewport :: forall options trash. Row.Union options trash (width :: Int, height :: Int) => { | options } -> Page -> Aff Unit
setViewport = runPromiseAffE2 _setViewport

frames :: Page -> Effect (Array Frame)
frames = FU.runFn1 _frames

name :: Frame -> Effect String
name = FU.runFn1 _name

frameWaitForSelector
  :: forall options trash
   . Row.Union options trash
       ( visible :: Boolean
       , hidden :: Boolean
       , timeout :: Int
       )
  => Selector
  -> { | options }
  -> Frame
  -> Aff ElementHandle
frameWaitForSelector = runPromiseAffE3 _frameWaitForSelector

frameSelect :: Selector -> Frame -> Aff ElementHandle
frameSelect = runPromiseAffE2 _frameSelect

elementClick :: ElementHandle -> Aff Unit
elementClick = runPromiseAffE1 _elementClick

pageType :: String -> Page -> Aff Unit
pageType = runPromiseAffE2 _pageType

cookies :: Page -> Aff (Array Cookie)
cookies p = Promise.toAffE $ _cookies p

runPromiseAffE1 :: forall a o. FU.Fn1 a (Effect (Promise o)) -> a -> Aff o
runPromiseAffE1 f a = Promise.toAffE $ FU.runFn1 f a

runPromiseAffE2 :: forall a b o. FU.Fn2 a b (Effect (Promise o)) -> a -> b -> Aff o
runPromiseAffE2 f a b = Promise.toAffE $ FU.runFn2 f a b

runPromiseAffE3 :: forall a b c o. FU.Fn3 a b c (Effect (Promise o)) -> a -> b -> c -> Aff o
runPromiseAffE3 f a b c =  Promise.toAffE $ FU.runFn3 f a b c

runPromiseAffE4 :: forall a b c d o. FU.Fn4 a b c d (Effect (Promise o)) -> a -> b -> c -> d -> Aff o
runPromiseAffE4 f a b c d =  Promise.toAffE $ FU.runFn4 f a b c d

foreign import puppeteer :: Puppeteer
foreign import _launch :: forall options. FU.Fn1 options (Effect (Promise Browser))
foreign import _newPage :: FU.Fn1 Browser (Effect (Promise Page))
foreign import _goto :: FU.Fn2 URL Page (Effect (Promise Unit))
foreign import _close :: FU.Fn1 Browser (Effect (Promise Unit))
foreign import _content :: FU.Fn1 Page (Effect (Promise String))
foreign import _screenshot :: forall options. FU.Fn2 options Page (Effect (Promise Buffer))
foreign import _pdf :: forall options. FU.Fn2 options Page (Effect (Promise Buffer))
foreign import _on :: forall a. EU.EffectFn3 String (EU.EffectFn1 a Unit) Page Unit
foreign import _pageWaitForSelector :: forall options. FU.Fn3 Selector options Page (Effect (Promise ElementHandle))
foreign import _focus :: FU.Fn2 Selector Page (Effect (Promise Unit))
foreign import _type :: forall options. FU.Fn4 Selector String options Page (Effect (Promise Unit))
foreign import _click :: FU.Fn2 Selector Page (Effect (Promise Unit))
foreign import _clickElement :: FU.Fn1 ElementHandle (Effect (Promise Unit))
foreign import _waitForNavigation :: forall options. FU.Fn2 options Page (Effect (Promise Unit))
foreign import _getLocationHref :: FU.Fn1 Page (Effect (Promise String))
foreign import _unsafeEvaluateStringFunction :: FU.Fn2 String Page (Effect (Promise Foreign))
foreign import _setUserAgent :: FU.Fn2 String Page (Effect (Promise Unit))
foreign import _allowDownloads :: FU.Fn2 String Page (Effect (Promise Unit))
foreign import _setViewport :: forall options. FU.Fn2 options Page (Effect (Promise Unit))
foreign import _frames :: FU.Fn1 Page (Effect (Array Frame))
foreign import _name :: FU.Fn1 Frame (Effect String)
foreign import _frameWaitForSelector :: forall options. FU.Fn3 Selector options Frame (Effect (Promise ElementHandle))
foreign import _frameSelect :: FU.Fn2 Selector Frame (Effect (Promise ElementHandle))
foreign import _elementClick :: FU.Fn1 ElementHandle (Effect (Promise Unit))
foreign import _pageType :: FU.Fn2 String Page (Effect (Promise Unit))
foreign import _addResponseListener :: FU.Fn2 ResponseListener Page (Effect Unit)
foreign import _removeResponseListener :: FU.Fn2 ResponseListener Page (Effect Unit)
foreign import responseListener :: (Response -> Effect Unit) -> Page -> Effect ResponseListener
foreign import request :: Response -> Effect Request
foreign import reqUrl :: Request -> Effect String
foreign import _cookies :: Page -> Effect (Promise (Array Cookie))
