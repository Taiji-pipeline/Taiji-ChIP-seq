module Taiji.Pipeline.ChIPSeq.Config where

import Bio.Pipeline.Utils (Directory)
import Bio.Pipeline.CallPeaks (CallPeakOpts)

class ChIPSeqConfig config where
    _chipseq_output_dir :: config -> Directory
    _chipseq_input :: config -> FilePath
    _chipseq_picard :: config -> Maybe FilePath
    _chipseq_bwa_index :: config -> Maybe FilePath
    _chipseq_genome_fasta :: config -> Maybe FilePath
    _chipseq_genome_index :: config -> Maybe FilePath
    _chipseq_motif_file :: config -> Maybe FilePath
    _chipseq_callpeak_opts :: config -> CallPeakOpts
