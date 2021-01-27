from stpipeline.common.utils import *
from stpipeline.core.mapping import alignReads, barcodeDemultiplexing
from stpipeline.core.annotation import annotateReads
from stpipeline.common.stats import qa_stats
from stpipeline.common.dataset import createDataset
from stpipeline.common.saturation import computeSaturation
from stpipeline.version import version_number
from taggd.io.barcode_utils import read_barcode_file
from stpipeline.common.filterInputReads import InputReadsFilter
import logging
import argparse
import sys
import shutil
import os
import tempfile
import subprocess
import pysam
import inspect

ref_annotation = sys.argv[3]
temp_folder="tempdir"
threads=8
htseq_mode = "intersection-nonempty"
htseq_no_ambiguous = True
include_non_annotated = False
strandness = "yes"
keep_discarded_files = False

input_file = sys.argv[1]
output_file = sys.argv[2]
output_discarded = "x"
annotateReads(input_file,
ref_annotation,
output_file,
output_discarded if keep_discarded_files else None,
htseq_mode, strandness,
htseq_no_ambiguous,
include_non_annotated,
temp_folder,
threads)
