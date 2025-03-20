This repository implements Ghost Imaging (GI) for sampling using various algorithms.

Files Overview

Generate_Uniform_Random_Matrices.m
A function for generating random speckle patterns.

RandomMatrices.m
Generates classic random speckle patterns.
Saves the generated patterns to:
data_illumination_field/random_matrix_uniform_64

TGI_DGI_NGI.m
Implements Ghost Imaging using traditional algorithms.

Usage Instructions

Run RandomMatrices.m first to generate and save random speckle patterns.
Execute TGI_DGI_NGI.m to apply GI algorithms using the generated patterns.
