# Toolkit for TSV (Tab-Separated Value) files

This toolkit is for making daily life easy on manipulation TSV files, including but not limited to loading, saving, viewing, subsetting, filtering, sorting, transposing, merging, joining the table-format files. In addition to TSV format, CSV, Excel (.xslx) and other common-using bioinformatics formats (such as BED, PSL) are also supported.

## Quick Installation

This toolkit is written by Perl, with minimum dependency on 3rd party packages/libraries. For fully functions, only a few perl packages are required, and it is easy to install them by CPAN.

The recommended way to install 'tsv' is by clone it from GitHub:

```
git clone https://github.com/yanlinlin82/tsv
```

and then add the 'tsv' directory to your environment variable PATH.

Alternatively, you can download only the 'tsv' file to any directory you want (and also add the directory to PATH):

```
# cd <any-path-you-want-to-put-tsv-in>
wget -N https://raw.githubusercontent.com/yanlinlin82/tsv/master/tsv
chmod +x tsv
./tsv install # this command will create symbolic links to assist command line operations
```

## Supported Functions

```
  align      align columns
  cat        show file content
  column     list columns
  filter     filter by conditions
  head       fetch head n rows
  join       join two tables by key column(s)
  merge      merge multiple files
  select     select columns
  sort       sort by column(s)
  subset     select rows (subset)
  summary    summary each column
  tail       fetch tail n rows
  to-excel   write to Excel (.xlsx) file
  transpose  matrix transpose
  version    show program version
  view       show file content, alias to 'cat'
```

## Data Source

The test data set `mtcars.txt` is exported from R package:

```sh
Rscript -e 'cat("name\t");write.table(mtcars,sep="\t",quote=FALSE)' > test/mtcars.txt
```
