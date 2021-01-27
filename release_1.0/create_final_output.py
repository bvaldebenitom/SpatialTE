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

umi_cluster_algorithm = "hierarchical"
umi_allowed_mismatches = 1
umi_counting_offset = 250
disable_umi = False

input_bam = sys.argv[1]
input_gtf = sys.argv[2]
experimentBasename = sys.argv[3]
#full output folder path
output_folder = sys.argv[4]

createDataset(input_bam,
qa_stats, # Passed as reference
input_gtf,
umi_cluster_algorithm,
umi_allowed_mismatches,
umi_counting_offset,
disable_umi,
output_folder,
experimentBasename,
True)

