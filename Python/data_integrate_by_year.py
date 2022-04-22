#!/usr/bin/python
import os
work_dir="F:/Spring 2022/EMD563 Lab and field studies/GitHub/Python"
os.chdir(work_dir)

year=[2017,2018,2019]
record_date=[]
for i in year:
    for eachLine in open('../Data/%s/date_of_record_%s.txt' % (i, i)):
        each = eachLine.split("\n")
        record_date.append([i,each[0]])

equip_data = []
def data_within_years(YEAR, DATE):
    line_num = 0
    for eachLine in open('../Data/%s/%s.csv' % (YEAR, DATE)):
        line_num += 1
        each = eachLine.split(',')
        if (line_num != 1):
            if (each[2] != '') and (each[1] != ''):
                global equip_data
                equip_data.append((int(float(each[2])), each[0], int(float(each[1])), each[3],
                                   each[5], each[8], each[9]))

for i in record_date:
    data_within_years(i[0], i[1])

equip_data=sorted(equip_data,key=lambda id:id[0])
equip_data2=[]
for i in equip_data:
    if i not in equip_data2:
        equip_data2.append(i)
equip_data=equip_data2

fjob = open('../Temp/data_integrate_2.txt', 'w', encoding='UTF-8')
fjob.write('equipment_specification_id,equipment_location_city,equipment_location_zip,equipment_intended_use,'
           'equipment_commissioned_date,equipment_last_legionella_sample_collection_date,'
           'legionella_exceedance_recode_text\n')
for i in equip_data:
    fjob.write('%d,%s,%d,%s,%s,%s,%s\n' % (i[0], i[1], i[2], i[3],i[4], i[5], i[6]))
fjob.close()

