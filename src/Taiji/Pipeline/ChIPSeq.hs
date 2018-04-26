{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}
module Taiji.Pipeline.ChIPSeq (inputReader, builder) where

import           Bio.Data.Experiment.Parser
import           Control.Lens
import           Control.Monad.IO.Class        (liftIO)
import           Control.Monad.Reader          (asks)
import           Scientific.Workflow

import           Taiji.Pipeline.ChIPSeq.Config
import qualified Taiji.Pipeline.ChIPSeq.Core   as Core

inputReader :: String -> Builder ()
inputReader key = do
    nodeS "Read_Input" [| \_ -> do
        input <- asks _chipseq_input
        liftIO $ if ".tsv" == reverse (take 4 $ reverse input)
            then readChIPSeqTSV input key
            else readChIPSeq input key
        |] $ do
            submitToRemote .= Just False
            note .= "Read ChIP-seq data information from input file."
    ["Read_Input"] ~> "Get_Peak"

builder :: Builder ()
builder = Core.builder
