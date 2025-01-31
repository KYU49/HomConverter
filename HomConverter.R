# --------------------------------------------------------------------------------------------------
#
#   MIT License
# 
#   Copyright (c) 2025 KYU @ https://github.com/KYU49
#
#   Permission is hereby granted, free of charge, to any person obtaining a copy of this software 
#   and associated documentation files (the "Software"), to deal in the Software without 
#   restriction, including without limitation the rights to use, copy, modify, merge, publish, 
#   distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the 
#   Software is furnished to do so, subject to the following conditions:
#
#   The above copyright notice and this permission notice shall be included in all copies or 
#   substantial portions of the Software.
#
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING 
#   BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
#   NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
#   DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
#   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
#   You should have received a copy of the The MIT License
#   along with this program.  If not, see <https://opensource.org/license/mit>.
#
# --------------------------------------------------------------------------------------------------

HomConverter <- setRefClass(
    Class = "HomConverter",
    fields = list(
        mouseDB = "data.frame",
        humanDB = "data.frame"
    ),
    methods = list(
        initialize = function(rptFile = "HOM_MouseHumanSequence.rpt"){
            m2h <- read.table(rptFile, sep="\t", header=T, comment.char = "")
            mouseDB <<- m2h[m2h$NCBI.Taxon.ID == 10090, c("DB.Class.Key", "EntrezGene.ID", "Symbol")]
            humanDB <<- m2h[m2h$NCBI.Taxon.ID == 9606, c("DB.Class.Key", "EntrezGene.ID", "Symbol")]
        },
        converter = function(fromDB, toDB, id, allow_multiple_hit){
            if(length(id) > 1){
                return(
                    c(
                        entrezGeneId = lapply(id, function(id){
                            converter(fromDB, toDB, id, allow_multiple_hit)$entrezGeneId
                        }),
                        symbol = lapply(id, function(id){
                            converter(fromDB, toDB, id, allow_multiple_hit)$symbol
                        })
                    )
                )
            }
            notFouond <- c(entrezGeneId = NA_integer_, symbol = NA)
            classKey <- fromDB[fromDB$EntrezGene.ID == id, "DB.Class.Key"]
            if(length(classKey) == 0) {
                return(notFouond)
            }
            results <- toDB[toDB$DB.Class.Key == classKey[1], c("EntrezGene.ID", "Symbol")]
            if(length(results) == 0) {
                return(notFouond)
            }

            if(allow_multiple_hit){
                return(
                    c(
                        entrezGeneId = results$EntrezGene.ID,
                        symbol = results$Symbol
                    )
                )
            }
            return(
                c(
                    entrezGeneId = results$EntrezGene.ID[1],
                    symbol = results$Symbol[1]
                )
            )
        },
        mouse2human = function(mouseEntrezId, allow_multiple_hit = FALSE){
            return(converter(mouseDB, humanDB, mouseEntrezId, allow_multiple_hit))
        },
        human2mouse = function(humanEntrezId, allow_multiple_hit = FALSE){
            return(converter(humanDB, mouseDB, humanEntrezId, allow_multiple_hit))
        }
    )
)
