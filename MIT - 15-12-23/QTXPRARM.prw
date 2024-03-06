#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} User Function QTXPRARM
    Exercício | Mensagem Totalizador
    @type  Function
    @author André Lucas
    @since 15/12/2023
    @version 0.1
    @see https://terminaldeinformacao.com/2017/11/04/lista-de-pontos-de-entrada-protheus/
/*/

User Function QTXPRARM()

    Local aArea    := GetArea()
    Local aAreaSCP := SCP->(GetArea())
    Local nCont    := 0
    Local nTotal   := 0
    Local nUP      := Len(aCols[1])
    Local cPosi    := AScan(aHeader, {|aX| Trim(aX[2])=="CP_ZZPRCSG"})

    for nCont := 1 to Len(aCols)
        if aCols[nCont][nUP] == .F.
            nTotal += aCols[nCont][cPosi]
        endif
    next  

    FwAlertInfo("Valor total sugerido para a solicitação R$ " + Transform(nTotal, "@E 999,999.99") + ".", "Valor Total Sugerido")

    RestArea(aAreaSCP)
    RestArea(aArea)

Return
