
-- Età

create temporary table banca.eta_clt as
select clt.id_cliente as id_clt_eta,
cast(datediff (current_date(), clt.data_nascita)/365 as SIGNED) as eta
from banca.cliente clt;

-- Numero di transazioni in uscita su tutti i conti
-- Numero di transazioni in entrata su tutti i conti
-- Importo transato in uscita su tutti i conti
-- Importo transato in entrata su tutti i conti

create temporary table banca.cnt_trans as
select cnt.id_cliente,
count(case when t_tran.segno="-" then 1 end) transazioni_uscita,
count(case when t_tran.segno="+" then 1 end) transazioni_entrata,
round(sum(case when t_tran.segno="-" then tran.importo else 0 end),2) importo_transazione_uscita,
round(sum(case when t_tran.segno="+" then tran.importo else 0 end),2) importo_transazione_entrata,

-- Numero totale di conti posseduti
-- Numero di conti posseduti per tipologia (un indicatore per tipo)

count(distinct cnt.id_conto) as num_conti,
count(distinct case when t_cnt.desc_tipo_conto = "Conto Base" then cnt.id_cliente end) as cnt_base,
count(distinct case when t_cnt.desc_tipo_conto = "Conto Business" then cnt.id_cliente end) as cnt_business,
count(distinct case when t_cnt.desc_tipo_conto = "Conto Privati" then cnt.id_cliente end) as cnt_privati,
count(distinct case when t_cnt.desc_tipo_conto = "Conto Famiglie" then cnt.id_cliente end) as cnt_famiglie,

-- Numero di transazioni in uscita per tipologia (un indicatore per tipo)
-- Numero di transazioni in entrata per tipologia (un indicatore per tipo)

count(case when t_tran.desc_tipo_trans = "Stipendio" then cnt.id_cliente end) as tran_entrata_stipendio,
count(case when t_tran.desc_tipo_trans = "Pensione" then cnt.id_cliente end) as tran_entrata_pensione,
count(case when t_tran.desc_tipo_trans = "Dividendi" then cnt.id_cliente end) as tran_entrata_dividendi,
count(case when t_tran.desc_tipo_trans = "Acquisto su Amazon" then cnt.id_cliente end) as tran_uscita_amazon,
count(case when t_tran.desc_tipo_trans = "Rata mutuo" then cnt.id_cliente end) as tran_uscita_mutuo,
count(case when t_tran.desc_tipo_trans = "Hotel" then cnt.id_cliente end) as tran_uscita_hotel,
count(case when t_tran.desc_tipo_trans = "Biglietto aereo" then cnt.id_cliente end) as tran_uscita_aereo,
count(case when t_tran.desc_tipo_trans = "Supermercato" then cnt.id_cliente end) as tran_uscita_supermercato,

-- Importo transato in uscita per tipologia di conto (un indicatore per tipo)
-- Importo transato in entrata per tipologia di conto (un indicatore per tipo)

round(sum(case when t_tran.segno="-" and t_cnt.desc_tipo_conto = "Conto Base" then tran.importo else 0 end),2) importo_trans_uscita_base,
round(sum(case when t_tran.segno="+" and t_cnt.desc_tipo_conto = "Conto Base" then tran.importo else 0 end),2) importo_trans_entrata_base,
round(sum(case when t_tran.segno="-" and t_cnt.desc_tipo_conto = "Conto Business" then tran.importo else 0 end),2) importo_trans_uscita_business,
round(sum(case when t_tran.segno="+" and t_cnt.desc_tipo_conto = "Conto Business" then tran.importo else 0 end),2) importo_trans_entrata_business,
round(sum(case when t_tran.segno="-" and t_cnt.desc_tipo_conto = "Conto Privati" then tran.importo else 0 end),2) importo_trans_uscita_privati,
round(sum(case when t_tran.segno="+" and t_cnt.desc_tipo_conto = "Conto Privati" then tran.importo else 0 end),2) importo_trans_entrata_privati,
round(sum(case when t_tran.segno="-" and t_cnt.desc_tipo_conto = "Conto Famiglie" then tran.importo else 0 end),2) importo_trans_uscita_famiglie,
round(sum(case when t_tran.segno="+" and t_cnt.desc_tipo_conto = "Conto Famiglie" then tran.importo else 0 end),2) importo_trans_entrata_famiglie

from banca.conto cnt
left join banca.tipo_conto t_cnt
on cnt.id_tipo_conto = t_cnt.id_tipo_conto
left join banca.transazioni tran
on cnt.id_conto = tran.id_conto
left join banca.tipo_transazione t_tran
on tran.id_tipo_trans = t_tran.id_tipo_transazione
group by 1
order by 1;

create table banca.tabella_finale as
select *
from banca.eta_clt c_eta
left join banca.cnt_trans cnt_t
on c_eta.id_clt_eta = cnt_t.id_cliente;
