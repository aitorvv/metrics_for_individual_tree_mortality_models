# ***Rethinking individual tree mortality model evaluation: are we using the right approach?***

### :computer: :floppy_disk: :bar_chart: *Original data, code and results related to the study*

---
<!--
:bulb: Have a look at the original poster  [here](http://dx.doi.org/10.13140/RG.2.2.27865.94564). -->
<!--
:bookmark: Poster DOI:  http://dx.doi.org/10.13140/RG.2.2.27865.94564 -->

:open_file_folder: Repository DOI: [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.15058864.svg)](https://doi.org/10.5281/zenodo.15058864)



📜 Manuscript DOI: <!-- https://doi.org/10.1016/j.ecolmodel.2024.110912 -->

---

## :sparkles: Highlights 

- Seven metrics were compared for evaluating individual tree mortality models 
- The same model showed different classification performance ranges across metrics 
- Best model selection varied depending on the chosen metric 
- AUCPR outperformed AUC when no confusion matrix was available 
- K and MCC are preferred when confusion matrix is available 

---

## :book: Abstract

Tree mortality plays a vital role in forest dynamics and is essential for growth models and simulators. Although factors such as competition, drought, and pathogens drive mortality, its underlying mechanisms remain difficult to model. While significant scientific attention has been given to selecting appropriate algorithms and covariates, evaluating individual tree mortality models also requires careful selection of performance metrics. This study compares seven different metrics to assess their impact on model evaluation and selection. Results show that candidate models exhibit varying performance ranges across metrics and that the choice of metric significantly influences the selection of the best model. When no confusion matrix is available, AUCPR emerges as a more reliable alternative to AUC, offering a balanced assessment for imbalanced datasets. When a confusion matrix is available, K and MCC outperform accuracy-based metrics, providing a fairer evaluation of both alive and dead tree classifications. These findings emphasize the importance of choosing appropriate evaluation metrics to enhance mortality model assessment and ensure reliable predictions in forestry applications. 

---
<!--
## :dart: Graphical abstract

![ga](./output/graphical_abstract.jpg)

--->

## :file_folder: Repository Contents

- :open_file_folder: [***bibliography***](./bibliography/): compilation of all the literature cited or consulted during the creation of the document
- :open_file_folder: [***data***](./data/): raw and processed data, check [here](./data/README.md) for a detailed description
- :open_file_folder: [***output***](./output/): figures, charts, tables and additional resources included in the document, check [here](./output/README.md) for a detailed description
- :open_file_folder: [***scripts***](./scripts/): compilation of the code used for data curation, analysis and outputs included in the document, check [here](./scripts/README.md) for a detailed description
  
---

## :thinking: How to use the resouces of that repository

:dizzy: To download the information of that repository, you can follow this [guide](https://docs.github.com/en/repositories/working-with-files/using-files/downloading-source-code-archives).

:recycle: To reproduce the analysis, users must:

- :floppy_disk: **Data**: 
  
    - Use the data located in the [data folder](./data/)

- :computer: **Prerequisites: installation and code**: *[R](https://cran.r-project.org/bin/windows/base/)* must be installed to run the code with the libraries used in each script. *[RStudio](https://posit.co/download/rstudio-desktop/)* was used to develop the code.

- :scroll: **Usage**: Details about the use of the provided code and its workflow are available [here](./data/README.md)

---

## 🔗 About the authors


#### Aitor Vázquez Veloso:

[![](https://github.com/aitorvv.png?size=50)](https://github.com/aitorvv) 

[![Email](https://img.shields.io/badge/Email-D14836?logo=gmail&logoColor=white)](mailto:aitor.vazquez.veloso@uva.es)
[![ORCID](https://img.shields.io/badge/ORCID-green?logo=orcid)](https://orcid.org/0000-0003-0227-506X)
[![Google Scholar](https://img.shields.io/badge/Google%20Scholar-4285F4?logo=google-scholar&logoColor=white)](https://scholar.google.com/citations?user=XNMn1cUAAAAJ&hl=es&oi=ao)
[![ResearchGate](https://img.shields.io/badge/ResearchGate-00CCBB?logo=researchgate&logoColor=white)](https://www.researchgate.net/profile/Aitor_Vazquez_Veloso)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-blue?logo=linkedin)](https://linkedin.com/in/aitorvazquezveloso/)
[![X](https://img.shields.io/badge/X-1DA1F2?logo=x&logoColor=white)](https://twitter.com/aitorvv)
[<img src="https://media.licdn.com/dms/image/v2/D4D0BAQFazHOlOJO50A/company-logo_200_200/company-logo_200_200/0/1692170343519/universidad_de_valladolid_logo?e=1747872000&v=beta&t=1mTS-xC7h3L_DQATdt6hpqjWGgW_Am3MXKnjYwcOVZs" alt="Description" width="22">](https://portaldelaciencia.uva.es/investigadores/178830/detalle)

#### Andrés Bravo Núñez:

<img src="https://media.licdn.com/dms/image/v2/C5603AQGwRR3P-w54rA/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1627411706088?e=1744848000&v=beta&t=VCuIdbLmoyRqLm_5L2yyWeCv2g83vyyedooTrCXhlKA" alt="Description" width="50"> 

[![ORCID](https://img.shields.io/badge/ORCID-green?logo=orcid)](https://orcid.org/0009-0003-6650-3487) 
[![ResearchGate](https://img.shields.io/badge/ResearchGate-00CCBB?logo=researchgate&logoColor=white)](https://www.researchgate.net/profile/Andres-Bravo-Nunez) 
[![LinkedIn](https://img.shields.io/badge/LinkedIn-blue?logo=linkedin)](https://www.linkedin.com/in/andbrav) 
[<img src="https://media.licdn.com/dms/image/v2/D4D0BAQFazHOlOJO50A/company-logo_200_200/company-logo_200_200/0/1692170343519/universidad_de_valladolid_logo?e=1747872000&v=beta&t=1mTS-xC7h3L_DQATdt6hpqjWGgW_Am3MXKnjYwcOVZs" alt="Description" width="22">](https://portaldelaciencia.uva.es/investigadores/874028/detalle)

#### Astor Toraño Caicoya:

<img src="https://www.lss.ls.tum.de/fileadmin/_processed_/f/0/csm_Picture20_57f925f9ae.webp" alt="Description" width="50"> 

[![ORCID](https://img.shields.io/badge/ORCID-green?logo=orcid)](https://orcid.org/0000-0002-9658-8990) 
[![ResearchGate](https://img.shields.io/badge/ResearchGate-00CCBB?logo=researchgate&logoColor=white)](https://www.researchgate.net/profile/Astor-Torano-Caicoya) 
[![LinkedIn](https://img.shields.io/badge/LinkedIn-blue?logo=linkedin)](https://www.linkedin.com/in/toranoac) 
[<img src="https://media.licdn.com/dms/image/v2/D4D0BAQEPj4W4lIWpzQ/company-logo_200_200/company-logo_200_200/0/1719581261705/technische_universitat_munchen_logo?e=1747872000&v=beta&t=qhZOKI6W0rq_w2zi1Ny9LYLtP8N6HiU7q-kFebd6hUI" alt="Description" width="22">](https://www.waldwachstum.wzw.tum.de/en/staff/astor-torano-caicoya/)

#### Hans Pretzsch:

<img src="https://www.professoren.tum.de/fileadmin/w00bgr/www/pics/PretzschHans.jpg" alt="Description" width="50"> 

[![ORCID](https://img.shields.io/badge/ORCID-green?logo=orcid)](https://orcid.org/0000-0002-4958-1868) 
[![ResearchGate](https://img.shields.io/badge/ResearchGate-00CCBB?logo=researchgate&logoColor=white)](https://www.researchgate.net/scientific-contributions/Hans-Pretzsch-38528857) 
[<img src="https://media.licdn.com/dms/image/v2/D4D0BAQEPj4W4lIWpzQ/company-logo_200_200/company-logo_200_200/0/1719581261705/technische_universitat_munchen_logo?e=1747872000&v=beta&t=qhZOKI6W0rq_w2zi1Ny9LYLtP8N6HiU7q-kFebd6hUI" alt="Description" width="22">](https://www.waldwachstum.wzw.tum.de/en/staff/hans-pretzsch/)

#### Felipe Bravo Oviedo:

[![](https://github.com/Felipe-Bravo.png?size=50)](https://github.com/Felipe-Bravo) 

[![ORCID](https://img.shields.io/badge/ORCID-green?logo=orcid)](https://orcid.org/0000-0001-7348-6695) 
[![ResearchGate](https://img.shields.io/badge/ResearchGate-00CCBB?logo=researchgate&logoColor=white)](https://www.researchgate.net/profile/Felipe-Bravo-11) 
[![LinkedIn](https://img.shields.io/badge/LinkedIn-blue?logo=linkedin)](https://www.linkedin.com/in/felipebravooviedo) 
[![X](https://img.shields.io/badge/X-1DA1F2?logo=x&logoColor=white)](https://twitter.com/fbravo_SFM) 
[<img src="https://media.licdn.com/dms/image/v2/D4D0BAQFazHOlOJO50A/company-logo_200_200/company-logo_200_200/0/1692170343519/universidad_de_valladolid_logo?e=1747872000&v=beta&t=1mTS-xC7h3L_DQATdt6hpqjWGgW_Am3MXKnjYwcOVZs" alt="Description" width="22">](https://portaldelaciencia.uva.es/investigadores/181874/detalle)

---

## ℹ License 

[![MIT License](https://img.shields.io/badge/license-MIT-red.svg)](./LICENSE)

The content of this repository is under the [MIT license](./LICENSE).


---

## :pencil: How to cite this repository?

You can use the [citation file](CITATION.cff) or copy the citation directly into APA or BibTeX using the bottom *Cite this repository* on the right hand side of the repository content, [here are more details](https://docs.github.com/es/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-citation-files).

---
<div style="text-align: center;">

[Metrics to evaluate individual tree mortality models](https://github.com/aitorvv/metrics_for_individual_tree_mortality_models) 

</div>
