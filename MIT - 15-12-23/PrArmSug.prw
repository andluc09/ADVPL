#INCLUDE 'TOTVS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TBICONN.CH'

/*/{Protheus.doc} User Function PrArmSug
    Exercício | Gatilho 
    @type  Function
    @author André Lucas
    @since 15/12/2023
    @version 0.1
    @see https://terminaldeinformacao.com/2021/07/08/como-criar-gatilhos-no-protheus/
/*/

User Function PrArmSug()

    Local nPrcSugd := 0
    Local cProd    := ""
    Local aArea    := GetArea()
    Local aAreaSB1 := SB1->(GetArea())
    Local aAreaSCP := SCP->(GetArea())

    DBSelectArea("SB1")
    SB1->(DBSetOrder(1))

    cProd := GDFieldGet("CP_PRODUTO",N)

    if SB1->(DBSeek(FwxFilial("SB1")+AllTrim(cProd)))
        nPrcSugd := (SB1->B1_UPRC) * (M->CP_QUANT)
    else
        nPrcSugd := 0.00
    endif

    RestArea(aAreaSCP)
    RestArea(aAreaSB1)
    RestArea(aArea)

Return nPrcSugd
