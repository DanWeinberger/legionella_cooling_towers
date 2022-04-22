#!/usr/bin/python
import os
work_dir="F:/Spring 2022/EMD563 Lab and field studies/GitHub/Python"
os.chdir(work_dir)

data=[]
line_num=0
for eachLine in open('../Temp/data_integrate.csv'):
    line_num+=1
    each=eachLine.split(',')
    if (line_num!=1):
        data.append((int(float(each[0])),each[1],int(float(each[2])),each[3],each[4],each[5],each[6]))
data2=[]
for i in data:
    if i not in data2:
        data2.append(i)
data=data2
fjob=open('../Temp/data_integrate2.txt','w',encoding='UTF-8')
fjob.write('equipment_specification_id,equipment_location_city,equipment_location_zip,equipment_intended_use,'
           'equipment_commissioned_date,equipment_last_legionella_sample_collection_date,'
           'legionella_exceedance_recode_text\n')
for i in range(len(data)):
    fjob.write('%s,%s,%s,%s,%s,%s,%s' % (data[i][0],data[i][1],data[i][2],data[i][3],data[i][4],data[i][5],data[i][6]))
fjob.close()

