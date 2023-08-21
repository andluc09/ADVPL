#INCLUDE "TOTVS.CH"
#INCLUDE "FWBROWSE.CH"

/*/{Protheus.doc} User Function TelaCTP
    1. Exercício | Tela: FwBrowse
    @type  Function
    @author André Lucas M. Santos
    @since 16/08/2023
    @version 0.1
    @see https://tdn.totvs.com/display/public/framework/FwBrowse
    @see https://tdn.totvs.com/display/public/framework/FWFormBrowse
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=62390842
/*/

User Function TelaCTP()

    CreateBrowse()

Return

Static Function CreateBrowse()

    Local oDlg      := NIL
    Local cQuery    := getQuery()
    Local cAlias    := getNextAlias()
	Local aColumns  := getColumns(cAlias)

    DEFINE DIALOG oDlg TITLE "Status Títulos a Pagar" FROM 0,0 TO 595,1275 PIXEL 

        oBrowse:= FWBrowse():New()
        oBrowse:SetOwner(oDlg)
        oBrowse:SetDescription("Status Títulos a Pagar")
        oBrowse:SetDataQuery(.T.)
        oBrowse:SetAlias(cAlias)
        oBrowse:SetColumns(aColumns)
        oBrowse:SetQuery(cQuery)
        oBrowse:DisableReport()
        oBrowse:Activate()

	ACTIVATE DIALOG oDlg

Return

Static Function getFields()

    Local aFields := {}

    AADD( aFields, "E2_PARCELA" )
    AADD( aFields, "E2_VENCREA" )
    AADD( aFields, "E2_VALOR" )
    AADD( aFields, "IIF(E2_BAIXA = '', CASE WHEN ISNUMERIC('R$ 0,00') = 0.00 THEN CAST(CAST(0.00 AS MONEY) AS FLOAT) END, SUM(E5_VALOR)) AS VLR_PAGO" )
    AADD( aFields, "E2_BAIXA" )

Return aFields

Static Function getQuery()

    Local aFields := getFields()
    Local cFields := ArrTokStr(aFields, ', ')
    Local cQuery  := ""  

    cQuery := " SELECT DISTINCT " + cFields + " FROM " + RetSqlName("SE2") + " AS SE2 "
    cQuery += ' INNER JOIN ' + RetSqlName('SE5') + ' AS SE5 '
    cQuery += " ON SE2.E2_FILIAL = '" + xFilial('SE2') + "' AND SE5.E5_FILIAL = '" + xFilial('SE5') + "' AND  "
    cQuery += ' SE2.E2_NOMFOR = SE5.E5_BENEF AND '
    cQuery += ' SE2.E2_PREFIXO = SE5.E5_PREFIXO AND '
    cQuery += ' SE2.E2_PARCELA = SE5.E5_PARCELA AND '
    cQuery += ' SE2.E2_TIPO = SE5.E5_TIPO AND '
    cQuery += ' SE2.E2_FORNECE = SE5.E5_CLIFOR AND '
    cQuery += " SE2.D_E_L_E_T_ = '' AND SE5.D_E_L_E_T_ = '' "
    cQuery += ' INNER JOIN ' + RetSqlName('SF1') + ' AS SF1 '
    cQuery += " ON SE2.E2_FILIAL = '" + xFilial('SE2') + "' AND SF1.F1_FILIAL = '" + xFilial('SF1') + "' AND "
    cQuery += ' SE2.E2_NUM = SF1.F1_DOC AND '
    cQuery += ' SE2.E2_PREFIXO =  SF1.F1_SERIE AND '
    cQuery += ' SE2.E2_FORNECE =  SF1.F1_FORNECE AND '
    cQuery += ' SE2.E2_LOJA =  SF1.F1_LOJA AND '
    cQuery += ' SE5.E5_LA = SF1.F1_NUMTRIB AND '
    cQuery += " SE2.D_E_L_E_T_ = '' AND SF1.D_E_L_E_T_ = '' "
    cQuery += " WHERE SF1.F1_DOC = '" + AllTrim(SF1->F1_DOC) + "' AND SE5.E5_RECPAG = 'P' "
    cQuery += ' GROUP BY E2_PARCELA, E2_VENCREA, E2_VALOR, E2_BAIXA '

Return cQuery

Static Function getColumns(cAlias)

    Local aFields  := getFields()
    Local cQuery   := getQuery()
    Local aTitles  := {"Parcela", "Vencimento", "Valor Original", "Valor Pago", "Data Pagamento"}
    Local aColumns := {}
    Local nFields  := 0
    Local cField   := ""

    for nFields := 1 to LEN( aFields )

        cAreaQuery := GetNextAlias()
        DBUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAreaQuery, .T., .T.)

        if (nFields == 4)
            aFields[nFields] := 'VLR_PAGO' //* Alias campo 
        endif

        cField := aFields[nFields] 
        AADD( aColumns, FWBrwColumn():New() )
        aColumns[Len(aColumns)]:SetID( cField )
        aColumns[Len(aColumns)]:SetTitle( aTitles[nFields] )
        aColumns[Len(aColumns)]:SetAlign(0)

        if(nFields <> 4)
            aColumns[Len(aColumns)]:SetSize( tamSX3(cField)[1] ) //? Tamanho
            aColumns[Len(aColumns)]:SetDecimal( tamSX3(cField)[2] ) //? Decimal
        endif

        if (cField == aFields[2] .OR. cField == aFields[5])
            aColumns[Len(aColumns)]:SetData(&("{|| STOD(" + cAlias + "->" + cField + ")}"))
        elseif (cField == aFields[3] .OR. cField == aFields[4])
            aColumns[Len(aColumns)]:SetData(&("{|| Transform(" + cAlias + "->" + cField + ", " + '"@E R$ 999999.99"' + ")}"))
        else
            aColumns[Len(aColumns)]:SetData(&("{||" + cAlias + "->" + cField + "}"))
        endif

    next nFields

    DBCloseArea()

Return aColumns
