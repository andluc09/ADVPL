#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} User Function QTXPRARM
    2. Exercício | Gatilho
    @type  Function
    @author André Lucas
    @since 17/08/2023
    @version 0.1
    @see https://terminaldeinformacao.com/2021/07/08/como-criar-gatilhos-no-protheus/
    /*/

User Function QTXPRARM()

    Local nCont  := 0
    Local nTotal := 0
    Local cPosi  := AScan(aHeader, {|aX| Trim(aX[2])=="CP_ZZPRCSG"})
    Local nUP    := Len(aCols[1])

    for nCont := 1 to Len(aCols)
        if aCols[nCont][nUP] == .F.
            nTotal += aCols[nCont][cPosi]
        endif
    next  

    FwAlertInfo("Valor total sugerido para a solicitação R$ " + Transform(nTotal, "@E 999,999.99" + "."), "Valor Total Sugerido")

Return NIL
