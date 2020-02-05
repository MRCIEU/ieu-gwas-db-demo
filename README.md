# Demo of IEU GWAS Database

Denis Baird, Yi Liu, Benjamin Elsworth

Steps to get the notebooks working:

```
# 1. install anaconda / miniconda

# 2. init env
conda env create -f environment.yml
conda activate ieu-gwas-db-demo

# 3. install r stuff
R
devtools::install_github("MRCIEU/ieugwasr")
# NOTE: this takes reaaaaally long
devtools::install_github("MRCIEU/TwoSampleMR")
```
