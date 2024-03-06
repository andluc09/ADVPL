
SELECT * FROM SC5990

SELECT * FROM SC6990

SELECT * FROM SA1990

SELECT SC5.C5_NUM,SC5.C5_EMISSAO,SC5.C5_ZZPDCLI,SC5.C5_ZZDTEMB,SC5.C5_FECENT,SC5.C5_ZZNCONT, SC5.C5_ZZOBPED,
SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_CGC FROM SC5990 AS SC5
INNER JOIN SA1990 SA1 ON SA1.A1_COD = SC5.C5_CLIENTE AND SA1.D_E_L_E_T_ = ' ' AND SA1.A1_FILIAL = ''
WHERE SC5.D_E_L_E_T_ = ' ' AND SC5.C5_FILIAL = 01
AND (SC5.C5_NUM BETWEEN '00015' AND 'PV005')
AND (CONVERT(VARCHAR,SC5.C5_EMISSAO,112) BETWEEN '20230101' AND '20231203')
ORDER BY SC5.C5_EMISSAO, SC5.C5_NUM 

SELECT SC5.C5_NUM,SC5.C5_EMISSAO,SC5.C5_ZZPDCLI,SC5.C5_ZZDTEMB,SC5.C5_FECENT,SC5.C5_ZZNCONT, SC5.C5_ZZOBPED,
SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_CGC FROM SC5990 AS SC5
INNER JOIN SA1990 SA1 ON SA1.A1_COD = SC5.C5_CLIENTE AND SA1.D_E_L_E_T_ = ' ' AND SA1.A1_FILIAL = ''
WHERE SC5.D_E_L_E_T_ = ' ' AND SC5.C5_FILIAL = 01
AND (SC5.C5_NUM BETWEEN '00015' AND 'PV021') 
AND (CONVERT(VARCHAR,SC5.C5_EMISSAO,112) BETWEEN '20230101' AND '20231203')
ORDER BY SC5.C5_EMISSAO, SC5.C5_NUM 

SELECT SC5.C5_NUM,SC5.C5_EMISSAO,SC5.C5_ZZPDCLI,SC5.C5_ZZDTEMB,SC5.C5_FECENT,SC5.C5_ZZNCONT, SC5.C5_ZZOBPED,
SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_CGC FROM SC5990 AS SC5
INNER JOIN SA1990 SA1 ON SA1.A1_COD = SC5.C5_CLIENTE AND SA1.D_E_L_E_T_ = ' ' AND SA1.A1_FILIAL = ''
WHERE SC5.D_E_L_E_T_ = ' ' AND SC5.C5_FILIAL = 01
AND (SC5.C5_NUM = 'PV0010')
AND (CONVERT(VARCHAR,SC5.C5_EMISSAO,112) BETWEEN '20230101' AND '20231203')
ORDER BY SC5.C5_EMISSAO, SC5.C5_NUM 

SELECT SC5.C5_NUM,SC5.C5_EMISSAO,SC5.C5_ZZPDCLI,SC5.C5_ZZDTEMB,SC5.C5_FECENT,SC5.C5_ZZNCONT, SC5.C5_ZZOBPED,
SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_CGC FROM SC5990 AS SC5
INNER JOIN SA1990 SA1 ON SA1.A1_COD = SC5.C5_CLIENTE AND SA1.D_E_L_E_T_ = ' ' AND SA1.A1_FILIAL = ''
WHERE SC5.D_E_L_E_T_ = ' ' AND SC5.C5_FILIAL = 01
AND (SC5.C5_NUM BETWEEN '00015' AND 'PV0005') 
AND (CONVERT(VARCHAR,SC5.C5_EMISSAO,112) BETWEEN '20230101' AND '20231204')
ORDER BY SC5.C5_EMISSAO, SC5.C5_NUM 

SELECT SC6.C6_NUM, SC6.C6_ITEMPC, SC6.C6_ZZPRCLI, SC6.C6_PRODUTO, SC6.C6_DESCRI, SC6.C6_QTDVEN, SC6.C6_ZZDESEN, SC6.C6_ZZESPEC, (SC6.C6_QTDVEN - SC6.C6_QTDENT) 'RELACAOQTD',
SC6.C6_ZZQTEMB, SC6.C6_ZZTPEMB, SC6.C6_ZZMEDID, SC6.C6_ZZLOTE, SC6.C6_ZZRELAT, SC6.C6_ZZPELIQ, SC6.C6_ZZPEBRU, SC6.C6_ZZPETOT, SC6.C6_NOTA, SC6.C6_ZZOBSEV FROM SC6990 AS SC6
WHERE SC6.D_E_L_E_T_ = ' ' AND SC6.C6_FILIAL = 01 
AND SC6.C6_NUM IN ('00015', 'PV0001', 'PV0002', 'PV0003', 'PV0004', 'PV0005')
ORDER BY SC6.C6_NUM, SC6.C6_PRODUTO

SELECT SC6.C6_NUM, SC6.C6_ITEMPC, SC6.C6_ZZPRCLI, SC6.C6_PRODUTO, SC6.C6_DESCRI, SC6.C6_QTDVEN, SC6.C6_ZZDESEN, SC6.C6_ZZESPEC, (SC6.C6_QTDVEN - SC6.C6_QTDENT) 'RELACAOQTD',
SC6.C6_ZZQTEMB, SC6.C6_ZZTPEMB, SC6.C6_ZZMEDID, SC6.C6_ZZLOTE, SC6.C6_ZZRELAT, SC6.C6_ZZPELIQ, SC6.C6_ZZPEBRU, SC6.C6_ZZPETOT, SC6.C6_NOTA, SC6.C6_ZZOBSEV FROM SC6990 AS SC6
WHERE SC6.D_E_L_E_T_ = ' ' AND SC6.C6_FILIAL = 01 
AND SC6.C6_NUM IN ('PV0003')
ORDER BY SC6.C6_NUM, SC6.C6_PRODUTO