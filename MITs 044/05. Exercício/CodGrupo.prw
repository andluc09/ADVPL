#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} User Function CodGrupo
    5. Exercício | Gatilho
    @type  Function
    @author André Lucas
    @since 29/08/2023
    @version 0.1
    @see https://terminaldeinformacao.com/2021/07/08/como-criar-gatilhos-no-protheus/
/*/

User Function CodGrupo()

    Local aArea   := GetArea()
    Local cCodigo := ""
    Local cGrupo  := FWFldGet("B1_GRUPO")
    Local cQryAux := ""
    Local nTamGrp := TamSX3('B1_GRUPO')[01]
    Local nTamCod := TamSX3('B1_COD')[01]

    if ! Empty(cGrupo)
        cCodigo := cGrupo + Replicate('0', nTamCod-nTamGrp)

        cQryAux := " SELECT "                                                                        + CRLF
        cQryAux += "     ISNULL(MAX(B1_COD), '" + cCodigo + "') AS ULTIMO "                          + CRLF
        cQryAux += " FROM "                                                                          + CRLF
        cQryAux += "     " + RetSQLName('SB1') + " SB1 "                                             + CRLF
        cQryAux += " WHERE "                                                                         + CRLF
        cQryAux += "     B1_FILIAL = '" + FWxFilial('SB1') + "' "                                    + CRLF
        cQryAux += "     AND B1_GRUPO = '" + cGrupo + "' "                                           + CRLF
        cQryAux += "     AND SUBSTRING(B1_COD, 1, " + cValToChar(nTamGrp) + ") = '" + cGrupo + "' "  + CRLF

        TCQuery cQryAux New Alias "QRY_AUX"

        cCodigo := Soma1(QRY_AUX->ULTIMO)

        QRY_AUX->(DbCloseArea())
    endif

    RestArea(aArea)

Return cCodigo
