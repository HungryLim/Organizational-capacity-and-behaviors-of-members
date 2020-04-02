from apiclient.discovery import build
#####################################################################
import os
import pandas
import glob
import numpy as np
import re
from apiclient.discovery import build

os.chdir("C:/Users/wooki/Desktop/new/lmforms/2012")
#read data
#colnames = ['youtube_id', 'title', 'url','youtube']
data = pandas.read_csv('lm_data_data_2012.csv')
list(data.columns)

data['STREET_ADR'][2]
data['CITY'][2]
data['STATE'][2]
data['ZIP'][2]
data['ZIP']= data['ZIP'].astype(np.str)

data['ZIP5'] = [x[:5] for x in data['ZIP']]


data['address'] = data['STREET_ADR'].str.cat(data[['CITY', 'STATE','ZIP5']], sep=' ')
data['address']

kk=data['address'][7]
kk
service = build('civicinfo','v2', developerKey="AIzaSyCCmgwExRYVzTR_o99hCCRY7PF9H3UiYHg")               
rep = service.representatives().representativeInfoByAddress(address = kk,includeOffices=True,roles='legislatorLowerBody')
response = rep.execute()
cd=response['divisions']
cdd=next(iter(cd))
cd_num = re.findall("\d+", cdd)[0]

############################################################
cd_final = [] 
for value in data["address"]: 
    try:
        service = build('civicinfo','v2', developerKey="put key in here")               
        rep = service.representatives().representativeInfoByAddress(address = value,includeOffices=True,roles='legislatorLowerBody')
        response = rep.execute()
        cd=response['divisions']
        cdd=next(iter(cd))
        cd_num = re.findall("\d+", cdd)[0]
        cd_final.append(cd_num)
    except:
        cd_final.append('Cannot_find')
        continue
cd_final
data["cong_dist"] = cd_final   
type(data)
data.to_csv('output.csv', index=False, header=True)

