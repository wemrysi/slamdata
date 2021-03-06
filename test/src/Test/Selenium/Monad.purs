module Test.Selenium.Monad where

import Prelude
import Data.Either 
import Data.Maybe 
import Data.List
import DOM 
import Test.Config (Config())
import Selenium
import Selenium.ActionSequence
import Selenium.Types
import Control.Monad.Eff.Console (CONSOLE())
import Control.Monad.Trans
import Control.Monad.Reader.Trans
import Control.Monad.Reader.Class 
import qualified Control.Monad.Aff as A


type Context =
  { config :: Config
  , driver :: Driver 
  }

type Check a = ReaderT Context
               (A.Aff (console :: CONSOLE, selenium :: SELENIUM, dom :: DOM)) a


-- READER 
getDriver :: Check Driver
getDriver = _.driver <$> ask

getConfig :: Check Config
getConfig = _.config <$> ask


-- AFF
apathize :: forall a. Check a -> Check Unit
apathize check = ReaderT \r -> 
  A.apathize $ runReaderT check r 

attempt :: forall a. Check a -> Check (Either _ a)
attempt check = ReaderT \r ->
  A.attempt $ runReaderT check r

later :: forall a. Int -> Check a -> Check a
later time check = ReaderT \r ->
  A.later' time $ runReaderT check r

-- SELENIUM
goTo :: String -> Check Unit
goTo url = do
  driver <- getDriver
  lift $ get driver url

waitCheck :: Check Boolean -> Int -> Check Unit
waitCheck check time = ReaderT \r -> do
  wait (runReaderT check r) time r.driver

css :: String -> Check Locator
css = lift <<< byCss

xpath :: String -> Check Locator
xpath = lift <<< byXPath

checkLocator :: (Element -> Check Element) -> Check Locator
checkLocator checkFn = ReaderT \r ->
  affLocator (\el -> runReaderT (checkFn el) r)

element :: Locator -> Check (Maybe Element)
element locator = do
  driver <- getDriver
  lift $ findElement driver locator

elements :: Locator -> Check (List Element)
elements locator = do
  driver <- getDriver
  lift $ findElements driver locator

child :: Element -> Locator -> Check (Maybe Element)
child el loc = lift $ findChild el loc

children :: Element -> Locator -> Check (List Element)
children el loc = lift $ findChildren el loc

innerHtml :: Element -> Check String
innerHtml  = lift <<< getInnerHtml

visible :: Element -> Check Boolean
visible = lift <<< isDisplayed

getCss :: Element -> String -> Check String
getCss el key = lift $ getCssValue el key

clear :: Element -> Check Unit
clear = lift <<< clearEl

keys :: String -> Element -> Check Unit
keys ks el = lift $ sendKeysEl ks el

script :: String -> Check Unit
script str = do
  driver <- getDriver
  lift $ executeStr driver str

getURL :: Check String
getURL = do
  getDriver >>= getCurrentUrl >>> lift

back :: Check Unit
back = do
  driver <- getDriver
  lift $ navigateBack driver


actions :: Sequence Unit -> Check Unit
actions seq = do
  driver <- getDriver
  lift $ sequence driver seq 

checker :: Check Boolean -> Check Boolean
checker check = do
  res <- check
  if res
    then pure true
    else later 1000 check
  
stop :: Check Unit
stop = waitCheck (later 1000000 $ pure false) 1000000
