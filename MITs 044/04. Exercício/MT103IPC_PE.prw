#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} User Function MT103IPC
    4. Exercício | Ponto de Entrada: MT103IPC
    @type  Function
    @author André Lucas
    @since 24/08/2023
    @version 0.1
    @see https://tdn.totvs.com/display/public/PROT/MT103IPC+-+Atualiza+campos+customizados+no+Documento+de+Entrada
/*/

User Function MT103IPC()

    Local aArea     := GetArea()
    Local nPosCod   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_COD" })
    Local nPosCampo := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="D1_ZZDESCR"})
    Local nAtual    := 0
    Local ExpN1     := PARAMIXB[1]

    if(ExpN1 == 1)
        for nAtual := 1 to Len(aCols)
            aCols[nAtual][nPosCampo]  := Posicione('SB1', 1, FWxFilial('SB1')+aCols[nAtual][nPosCod], "B1_DESC")
        next
    endif

    FWRestArea(aArea)

Return 
