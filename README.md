# Toolkit for TSV (Tab-Separated Value) files

This toolkit is for making daily life easy on manipulation TSV files, including but not limited to loading, saving, viewing, subsetting, filtering, sorting, transposing, merging, joining the table-format files. In addition to TSV format, CSV, Excel (.xslx) and other common-using bioinformatics formats (such as BED, PSL) are also supported.

## Quick Installation

This toolkit is written by Perl, with minimum dependency on 3rd party packages/libraries. For fully functions, only a few perl packages are required, and it is easy to install them by CPAN.

The recommended way to install 'tsv' is by clone it from GitHub:

```sh
git clone https://github.com/yanlinlin82/tsv
```

and then add the 'tsv' directory to your environment variable PATH.

Alternatively, you can download only the 'tsv' file to any directory you want (and also add the directory to PATH):

```sh
# cd <any-path-you-want-to-put-tsv-in>
wget -N https://raw.githubusercontent.com/yanlinlin82/tsv/master/tsv
chmod +x tsv
./tsv install # this command will create symbolic links to assist command line operations
```

Install dependencies:

```sh
# sudo apt install carton
carton install
alias tsv='carton exec -- tsv'
```

## Supported Functions

```txt
- Viewing
    cat           show original content
    align         align columns
    view          view file content in pretty better format
    column        list column names

- Selecting
    select        select columns
    select-rows   select rows
    head          select head n rows
    tail          select tail n rows
    filter        filter by conditions

- Editing
    cleanup       remove empty rows or columns
    transpose     matrix transpose
    mutate        add/update column valies

- Manipulating
    sort          sort by column(s)
    merge         merge multiple files
    join          join two tables by key column(s)

- Counting
    dim           show matrix dimension
    count         count column values
    summary       summary each column

- Writing
    to-csv        write to CSV file
    to-xlsx       write to Excel (.xlsx) file

- Others
    version       show program version
```

## Data Source

The test data set `mtcars.txt` is exported from R package:

```sh
Rscript -e 'cat("name\t");write.table(mtcars,sep="\t",quote=FALSE)' > test/mtcars.txt
```
