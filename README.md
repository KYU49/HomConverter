** The English text in the README.md is a machine translation from Japanese. **

# About
このツールは、マウスとヒトの遺伝子間でホモロジーのある遺伝子のEntrez Gene ID (GSEA解析などで使われる)を相互に変換するRのスクリプトです。

This tool is an R script that converts the Entrez Gene IDs of homologous genes between mouse and human (used in analyses such as GSEA).

# Requirements
* Access the following URL:  
  http://www.informatics.jax.org/homology.shtml
* Download the file named "HOM_MouseHumanSequence.rpt" from the link,  
  "Complete List of Human and Mouse Homologs (plain text)" 
* Place it in the same directory as the script.

# Usage
## Initialization
```R
source("HomConverter.R")
conv <- HomConverter("HOM_MouseHumanSequence.rpt")    # arg is path of the rpt file.
```

## Convert EntrezGeneID from Mouse to Human
```R
result <- conv$mouse2human(Your_Interest_EntrezGeneID_of_mouse)
print(result$entrezGeneId)    # If input is `107747` (EntrezGeneID of Aldh1l1), output is `[1] 10840`
print(reulst$symbol)          # If input is `107747`, output is `[1] ALDH1L1`
```

## Convert EntrezGeneID from Human to Mouse
```R
result <- conv$human2mouse(Your_Interest_EntrezGeneID_of_human)
print(result$entrezGeneId)
print(reulst$symbol)
```

## Convert list of EntrezGeneIDs from Mouse to Human
```R
result <- conv$mouse2human(c(id1, id2, id3, ...))
print(result[[1]]$entrezGeneId) # EntrezGeneID of Human converted from id1
```

## Not 1:1 but 1:many convert

* `66483` is EntrezGeneID for the mouse gene Rpl36al, while in humans, it corresponds to the gene RPL36A and RPL36AL.
```R
result <- conv$mouse2human(66483, allow_multiple_hit = TRUE)
print(result$symbol)        # `[1] "RPL36A"  "RPL36AL"`
print(result$entrezGeneId)  # `[1] 6173 6166`
print(result$symbol[1])     # `[1] "RPL36A"`
```

* If `allow_multiple_hit` is FALSE (default), the first one that is found will be returned as the output.
```R
result <- conv$mouse2human(66483)
print(result$symbol)     # `[1] "RPL36A"`
```

## When corresponding gene is not found
```R
result <- conv$mouse2human(0) # Not existing EntrezGeneID
print(result$entrezGeneId)    # `[1] NA`
print(result$symbol)          # `[1] "NA"`. Attention: "NA" is text not NA.
```


# License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.