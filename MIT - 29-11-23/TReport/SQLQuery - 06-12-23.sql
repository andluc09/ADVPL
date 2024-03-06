
SELECT C5_NUM, C5_EMISSAO, C5_ZZPDCLI, C5_ZZDTEMB, C5_FECENT, C5_ZZNCONT, C5_ZZOBPED, 
C6_ITEMPC, C6_ZZPRCLI, C6_PRODUTO, C6_DESCRI, C6_QTDVEN, C6_ZZDESEN, C6_ZZESPEC, CAST((C6_QTDVEN - C6_QTDENT) AS VARCHAR) AS 'QTDPCFATUR', C6_ZZQTEMB, C6_ZZTPEMB, C6_ZZMEDID, C6_ZZLOTE, C6_ZZRELAT, C6_ZZPELIQ, C6_ZZPEBRU, C6_ZZPETOT, C6_NOTA, C6_ZZOBSEV,
(A1_COD + ' - ' + A1_LOJA + ' - ' + A1_NOME) AS 'CLIENTE', A1_CGC
FROM SC5990 AS SC5 
INNER JOIN  SC6990 AS SC6 ON SC6.C6_FILIAL = SC5.C5_FILIAL AND SC6.C6_NUM = SC5.C5_NUM AND SC6.D_E_L_E_T_ = SC5.D_E_L_E_T_    
INNER JOIN  SA1990 AS SA1 ON SA1.A1_FILIAL = '' AND SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.D_E_L_E_T_ = SC5.D_E_L_E_T_   
WHERE SC5.C5_NUM BETWEEN 'PV0005' AND 'PV0005' AND  
SC5.C5_EMISSAO BETWEEN '20230101' AND '20231230' AND
SC5.C5_FILIAL = '01' AND SC6.C6_FILIAL = '01' AND SA1.A1_FILIAL = '' AND
SC5.D_E_L_E_T_ = '' AND SC6.D_E_L_E_T_ = '' AND SA1.D_E_L_E_T_ = ''   
ORDER BY SC5.C5_EMISSAO, SC5.C5_NUM