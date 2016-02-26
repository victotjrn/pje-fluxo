#!/usr/bin/python
# coding: utf-8

import psycopg2
import os
import env

con = None

try:
    con = psycopg2.connect(host=env.DB_HOST, user=env.DB_USER, password=env.DB_PASS, database=env.DB_NAME, port=env.DB_PORT)

    cur = con.cursor()
    cur.execute("SELECT ds_fluxo, ds_xml FROM tb_fluxo WHERE ds_fluxo ilike '%" + env.SQL_LIKE_CRITERIA + "%'")
except psycopg2.DatabaseError, e:
    print 'Erro ao tentar conexão com o banco: %s' % e
    sys.exit(1)

if cur.rowcount == 0:
    print "Nenhum fluxo foi encontrado com os critérios informados. Backup não realizado!"
    raise SystemExit(0)

rows = cur.fetchall()

dst_dir = env.PATH_DESTINATION

if not os.path.exists(dst_dir):
    os.makedirs(dst_dir)

for row in rows:
    file = open(dst_dir + '/' + row[0].decode('latin1') + '.xml', "w")
    file.write(row[1])
    file.close()

print "Backup realizado com sucesso!"
