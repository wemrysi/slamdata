module Config where

import Prelude ((<>))

baseUrl :: String
baseUrl = ""

serviceBaseUrl :: String
serviceBaseUrl = "/"

uploadUrl :: String
uploadUrl = serviceBaseUrl <> "upload"

metadataUrl :: String
metadataUrl = serviceBaseUrl <> "metadata/fs/"

mountUrl :: String
mountUrl = serviceBaseUrl <> "mount/fs/"

dataUrl :: String
dataUrl = serviceBaseUrl <> "data/fs/"

queryUrl :: String
queryUrl = serviceBaseUrl <> "query/fs/"

serverInfoUrl :: String
serverInfoUrl = serviceBaseUrl <> "server/info"

browserUrl :: String
browserUrl = baseUrl <> "index.html"

notebookUrl :: String
notebookUrl = baseUrl <> "notebook.html"

searchTimeout :: Int
searchTimeout = 500

slamDataHome :: String
slamDataHome = baseUrl <> "index.html"

userEnabled :: Boolean
userEnabled = false

newFolderName :: String
newFolderName = "Untitled Folder"

folderMark :: String
folderMark = ".folder"

notebookExtension :: String
notebookExtension = "slam"

newNotebookName :: String
newNotebookName = "Untitled Notebook"

newFileName :: String
newFileName = "Untitled File"

newDatabaseName :: String
newDatabaseName = "Untitled Database"

homeHash :: String
homeHash = "index.html#?sort=asc&q=path%3A%2F&salt="

notebookNameEditorId :: String
notebookNameEditorId = "name-editor"

defaultPageSize :: Int
defaultPageSize = 10

notifyTimeout :: Int
notifyTimeout = 500

resizeEChartsTimeout :: Int
resizeEChartsTimeout = 0

trashFolder :: String
trashFolder = ".trash"
