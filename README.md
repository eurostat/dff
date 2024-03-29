dff
===

The Dominick's Finer Foods data set: 
Promoting the use of a publicly available scanner data set in price index research and for capacity building.
---

The present material demonstrates how a publicly available scanner data set can be used for price index research 
and capacity building.

**<a name="Data_source"></a>Data source**

The Dominick's Finer Foods (a now-defunct Chicago-area grocery store chain) data set is a publicly available 
scanner dataset that is provided for academic research purposes only. It contains sales information at the store 
level on a weekly basis for each UPC (Universal Product Code) in a category. 
The data set covers more than 90 stores for almost 400 weeks from September 1989 to May 1997 and totals around 
100 million observations (after cleansing) of about 18 000 UPCs (including re-launches) in 29 categories (from 
analgesics to toothpastes).

**<a name="Overview"></a>Overview**

The documentation located in the [_docs/_](docs) folder introduces the data set and describes how the data can be acquired 
and pre-processed, followed by a presentation of the estimation of price index numbers showing the usefulness for 
both research and training purposes. The codes used are located in the [_SAS/_](SAS) folder. The newly-made `CSV` files 
(see link below) should be used to run the code located in the [_R/_](R) folder. Both sets of code allow generating 
analysis-ready data and basing calculations on the very same data, thus discounting the incomparability of different 
data sets.

In order to run the codes, it is necessary to download (and extract) all category-specific files, _i.e._ the UPC files 
and movement files (in `SAS` format for the `SAS` codes, in `CSV` format for the `R` code) from the website of the 
James M. Kilts Center at the University of Chicago Booth School of Business:
[https://www.chicagobooth.edu/research/kilts/datasets/dominicks](https://www.chicagobooth.edu/research/kilts/datasets/dominicks).

Furthermore, we provide two files located in the [_CSV/_](CSV) folder that prepare the information on the week variable 
and the stores included that was covered only in Dominick's Data Manual.

**<a name="Description"></a>Description**

* [**_CSV/_**](CSV): These files are needed to run the `SAS` code and `R` code, respectively.
The weeks file codes the week for which a data point is recorded. The stores file lists the stores included 
in the Dominick's research project.
The `upcrfj` file provides the UPC file information for refrigerated juices (_'RFJ'_) in a `SAS` readable format 
(see documentation about acquiring the data in the [_docs/_](docs) folder). Note that, if using `R`, there is no 
movement file available in `CSV` format for refrigerated juices from the Dominick's website.
* [**_SAS/_**](SAS): The `SAS` codes replicate the data and results of the paper located in the [_docs/_](docs) folder.
The `upc` part reads in all UPC files and adds a category identifier. The `move` part reads in all movement files, 
adds a category identifier, and calculates total dollar sales; suspect data are dropped. The `weeks_stores` part 
reads in the week and store files and merges them with the movement and UPC files. The `wtpd` example aggregates 
the data, calculates unit prices as well as expenditure shares per category, and derives price indices by means 
of the weighted time-product dummy (`WTPD`) method.
The `sas2csv` code was used to convert `SAS` files to the `CSV` format newly available at the Dominick's website. The 
`CSV` files are provided to make them more useful to researchers.
* [**_R/_**](R): The `R` code generates analysis-ready data and derives price indices equivalent to the `SAS` codes 
(located in the [_SAS/_](SAS) folder). Common to the two sets of codes is that for the sake of exposition the weekly 
store-level UPC data are aggregated to chain-wide item codes (attempt at tracking products across multiple UPCs) at 
monthly frequency – but this can be changed. The difference is that while the `SAS` codes calculate results for each 
category, the `R` code is restricted to one particular category, where the three-letter acronym for the category can 
be adapted. The folder includes two `R` codes that both create the same results. The first code can be run with the `R` 
base package whereas the second code requires the installation of the `tidyverse` package.
* [**_docs/_**](docs): The documentation includes the [paper](docs/dff.pdf) demonstrating how the data set can be used for price 
index research and capacity building as well as the `SAS` output from the weighted time-product dummy method at monthly 
frequency across all 29 categories in `CSV` format. Note that, if using `R`, there is a small loss of information between 
conversion in the 'truncated' `PRICE` variable in the `CSV` files.
The [annex to the paper](docs/dff_r.pdf) gives instructions on how to use the `R` code located in the [_R/_](R) folder.

**About**

<table align="center">
    <tr>     <td  rowspan="4" align="center" width="120px"> <a href="docs/dff.pdf"><img src="docs/article_front_cover.png"></img></a></td>
             <td align="left"><i>author</i></td> <td align="left"> <a href="mailto:jens.mehrhoff@bundesbank.de">Mehrhoff J.</a></td> </tr> 
    <tr> <td align="left"><i>status</i></td> <td align="left">since 2018 &ndash; <b>closed</b></td></tr>     
    <tr> <td align="left"><i>version</i></td> <td align="left">2.0</td> </tr> 
    <tr> <td align="left"><i>license</i></td> <td align="left"><a href="https://joinup.ec.europa.eu/sites/default/files/eupl1.1.-licence-en_0.pdfEUPL">EUPL</a> <i>(cite the source code or the reference below!)</i></td> </tr> 
</table>

**<a name="References"></a>References** 

* Kilts Center for Marketing (2013, updated 2018): [Dominick's Data Manual](https://www.chicagobooth.edu/-/media/enterprise/centers/kilts/datasets/dominicks-dataset/dominicks-manual-and-codebook_kiltscenter.aspx), Chicago.

* Mehrhoff, J. (2018): [**Promoting the use of a publicly available scanner data set in price index research and for 
capacity building**](docs/dff.pdf), Luxembourg.

