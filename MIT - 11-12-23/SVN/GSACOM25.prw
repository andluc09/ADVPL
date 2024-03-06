#Include "PROTHEUS.CH"

//TIPO: Funcao
//ROTINA: Retirada e Entrega no Documento de Entrada
//AUTOR: Clayton Carlos Nogueira
//DATA: 26/07/2022
//MIT044IP - Retirada e Entrega

User Function GSACOM25()

// Variaveis dos Campos internos
Static dtretoGet
Static dtretcGet
Static hrretoGet
Static hrretcGet
Static dtentoGet
Static dtentcGet
Static hrentoGet
Static hrentcGet

// Legenda titulo dos campos
Local dtretoSay
Local hrretoSay
Local dtentoSay
Local hrentoSay

Local Sair
Static oDlg

// Le valor dos campos no BD para exibir
dtretcGet := SF1->F1_ZZDTRET
hrretcGet := SF1->F1_ZZHRRET
dtentcGet := SF1->F1_ZZDTENT
hrentcGet := SF1->F1_ZZHRENT

DEFINE MSDIALOG oDlg TITLE "Retirada e Entrega" FROM 000, 000 TO 230, 250 COLORS 0, 16777215 PIXEL

// Exibi Titulo dos campos em tela
@ 010, 010 SAY dtretoSay PROMPT "Data Retirada: " SIZE 065, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 025, 010 SAY hrretoSay PROMPT "Hora Retirada: " SIZE 065, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 053, 010 SAY dtentoSay PROMPT "Data Entrega: " SIZE 065, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 068, 010 SAY hrentoSay PROMPT "Hora Entrega: " SIZE 065, 007 OF oDlg COLORS 0, 16777215 PIXEL

// Get dos campos
@ 007, 060 MSGET dtretoGet VAR dtretcGet SIZE 050, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 023, 060 MSGET hrretoGet VAR hrretcGet PICTURE "@E 99:99:99" SIZE 030, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 050, 060 MSGET dtentoGet VAR dtentcGet SIZE 050, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 065, 060 MSGET hrentoGet VAR hrentcGet PICTURE "@E 99:99:99" SIZE 030, 010 OF oDlg COLORS 0, 16777215 PIXEL

//dtretoGet:Disable()

// Cria botoes
@ 095, 020 BUTTON Alterar PROMPT "Confirmar" SIZE 037, 012 OF oDlg PIXEL Action U_SalvaRetEnt() //Of oDlg
@ 095, 074 BUTTON Sair PROMPT "Cancelar" SIZE 037, 012 OF oDlg PIXEL Action oDlg:End()

ACTIVATE MSDIALOG oDlg CENTERED

Return

// Salva alteracoes no BD do documento de entrada ao confirmar
User Function SalvaRetEnt()

	dbSelectArea("SF1")
		RecLock("SF1",.F.)  
		
		If SF1->F1_ZZDTRET	<> dtretcGet
		//U_fincluilog("ALTEROU DT. RETIRADA DE: "+DTOC(SF1->F1_ZZDTRET)+" - PARA: "+DTOC(dtretcGet))
		//SF1->F1_ZZDTRET	:= dtretcGet
		Endif
		
		If SF1->F1_ZZHRRET <> hrretcGet
		//U_fincluilog("ALTEROU HR. RETIRADA DE: "+DTOC(SF1->F1_ZZHRRET)+" - PARA: "+DTOC(hrretcGet))
		//SF1->F1_ZZHRRET	:= hrretcGet
		Endif
		
		If SF1->F1_ZZDTENT	<> dtentcGet
		//U_fincluilog("ALTEROU DT. ENTREGA DE: "+DTOC(SF1->F1_ZZDTENT)+" - PARA: "+DTOC(dtentcGet))
		//SF1->F1_ZZDTENT	:= dtentcGet
		Endif
		
		If SF1->F1_ZZHRENT <> hrentcGet
		//U_fincluilog("ALTEROU HR. ENTREGA DE: "+DTOC(SF1->F1_ZZHRENT)+" - PARA: "+DTOC(hrentcGet))
		//SF1->F1_ZZHRENT := hrentcGet
		Endif
	

		SF1->F1_ZZDTRET	:= dtretcGet
		SF1->F1_ZZHRRET := hrretcGet
		SF1->F1_ZZDTENT	:= dtentcGet
		SF1->F1_ZZHRENT := hrentcGet
	MsUnlock()
	
	dbCloseArea("SF1")
	// CHAMA ROTINA GRAVA LOG
	//U_fincluilog("CCN2")
	oDlg:End()

Return
