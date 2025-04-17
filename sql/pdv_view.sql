DROP VIEW IF EXISTS vw_hora_dia;
CREATE VIEW vw_hora_dia AS
	SELECT 0 AS hora UNION ALL SELECT 1
		UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
		UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
		UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13
		UNION ALL SELECT 14 UNION ALL SELECT 15 UNION ALL SELECT 16 UNION ALL SELECT 17
		UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL SELECT 20 UNION ALL SELECT 11
		UNION ALL SELECT 22 UNION ALL SELECT 23;

	SELECT * FROM vw_hora_dia;

DROP VIEW IF EXISTS vw_usuario;
CREATE VIEW vw_usuario AS
	SELECT id,email,access,nome,cadastro,expira,
	IF(access=0,"ROOT",IFNULL((SELECT nome FROM tb_usr_perm_perfil WHERE USR.access = id),"DESCONHECIDO")) AS perfil 
	FROM tb_usuario AS USR;

SELECT * FROM vw_usuario;

 DROP VIEW IF EXISTS vw_prod;
 CREATE VIEW vw_prod AS 
    SELECT 
        PROD.*,FORN.fantasia AS fornecedor,
        ROUND(((PROD.markup/100 + 1)*PROD.custo),2) AS preco
    FROM
        tb_produto AS PROD
	JOIN tb_empresa AS FORN
	ON FORN.id = PROD.id_emp
	GROUP BY PROD.id;
    
 SELECT * FROM vw_prod;
 
  DROP VIEW vw_comanda;
 CREATE VIEW vw_comanda AS     
	SELECT COM.*, CLI.nome AS cliente, CLI.cpf, CLI.cel,
    ROUND(IFNULL((SELECT  SUM(qtd * val_unit) FROM tb_item_comanda WHERE id_comanda=COM.id),0),2) AS total
		FROM tb_comanda AS COM
        INNER JOIN tb_cliente AS CLI
        ON COM.id_cliente = CLI.id
		ORDER BY entrada DESC;

 SELECT * FROM vw_comanda;

 DROP VIEW vw_item_comanda;
 CREATE VIEW vw_item_comanda AS  
	SELECT ITN.*, PROD.preco, ROUND((ITN.qtd * PROD.preco),2) AS sub_total, PROD.descricao, PROD.und 
    FROM tb_item_comanda AS ITN
    INNER JOIN vw_prod AS PROD
    ON ITN.id_produto = PROD.id;

	SELECT * FROM vw_item_comanda;