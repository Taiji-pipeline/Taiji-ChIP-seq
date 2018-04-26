{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module Main where

import           Bio.Pipeline.CallPeaks
import           Bio.Pipeline.Utils
import           Control.Lens                  ((&), (.=), (.~))
import           Data.Aeson                    (FromJSON, ToJSON)
import           Data.Default
import           GHC.Generics                  (Generic)
import           Scientific.Workflow
import           Scientific.Workflow.Main      (MainOpts (..), defaultMainOpts,
                                                mainWith)
import           Taiji.Pipeline.ChIPSeq        (inputReader, builder)
import qualified Taiji.Pipeline.ChIPSeq.Config as C

data ChIPSeqOpts = ChIPSeqOpts
    { outputDir :: Directory
    , bwaIndex  :: Maybe FilePath
    , genome    :: Maybe FilePath
    , input     :: FilePath
    , picard    :: Maybe FilePath
    } deriving (Generic)

instance C.ChIPSeqConfig ChIPSeqOpts where
    _chipseq_output_dir = outputDir
    _chipseq_bwa_index = bwaIndex
    _chipseq_genome_fasta = genome
    _chipseq_input = input
    _chipseq_picard = picard
    _chipseq_callpeak_opts _ = def & mode .~ NoModel (-100) 200

instance Default ChIPSeqOpts where
    def = ChIPSeqOpts
        { outputDir = asDir "output"
        , bwaIndex = Nothing
        , genome = Nothing
        , input = "input.yml"
        , picard = Nothing
        }

instance FromJSON ChIPSeqOpts
instance ToJSON ChIPSeqOpts

initialization :: () -> WorkflowConfig ChIPSeqOpts ()
initialization _ = return ()

mainWith defaultMainOpts { programHeader = "Taiji-ChIP-Seq" } $ do
    nodeS "Initialization" 'initialization $ submitToRemote .= Just False
    ["Initialization"] ~> "Read_Input"
    inputReader "ChIP-seq"
    builder
