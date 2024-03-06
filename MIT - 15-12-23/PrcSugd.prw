#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TBICONN.CH'

/*/{Protheus.doc} User Function PrcSugd
    Exercício | Gatilho 
    @type  Function
    @author André Lucas
    @since 15/12/2023
    @version 0.1
    @see https://terminaldeinformacao.com/2021/07/08/como-criar-gatilhos-no-protheus/
/*/

User Function PrcSugd(cProduto, nQuant)

    Local nPrcSugd := 0
    Local aArea    := GetArea()
    Local aAreaSB1 := SB1->(GetArea())
    Local aAreaSC1 := SC1->(GetArea())
    Local aAreaSCP := SCP->(GetArea())

    DBSelectArea("SB1")
    SB1->(DBSetOrder(1))

    if SB1->(DBSeek(FwxFilial("SB1")+AllTrim(cProduto)))
        nPrcSugd := (SB1->B1_UPRC)*nQuant
    else
        nPrcSugd := 0.00
    endif

    RestArea(aAreaSCP)
    RestArea(aAreaSC1)
    RestArea(aAreaSB1)
    RestArea(aArea)

Return nPrcSugd
