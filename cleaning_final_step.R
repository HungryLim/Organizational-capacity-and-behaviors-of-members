
#read data; I cannot share the data for this project, but the data is basically large administrative data from the U.S. department of Labor
cd_unions1<-read.csv('')
cd_unions2<-read.csv('')
cd_unions3<-read.csv('')

cd_unions<-rbind(cd_unions1,cd_unions2,cd_unions3)
rm(cd_unions1)
rm(cd_unions2)
rm(cd_unions3)

table(cd_unions$YR_COVERED)

cd_unions07<-subset(cd_unions,cd_unions$YR_COVERED==2007)
cd_unions08<-subset(cd_unions,cd_unions$YR_COVERED==2008)
cd_unions09<-subset(cd_unions,cd_unions$YR_COVERED==2009)
cd_unions10<-subset(cd_unions,cd_unions$YR_COVERED==2010)
cd_unions11<-subset(cd_unions,cd_unions$YR_COVERED==2011)
cd_unions12<-subset(cd_unions,cd_unions$YR_COVERED==2012)
cd_unions13<-subset(cd_unions,cd_unions$YR_COVERED==2013)

unique_cd_unions07<-cd_unions07[!duplicated(cd_unions07[,c('RPT_ID','STATE')]),]
unique_cd_unions08<-cd_unions08[!duplicated(cd_unions08[,c('RPT_ID','STATE')]),]
unique_cd_unions10<-cd_unions10[!duplicated(cd_unions10[,c('RPT_ID','STATE')]),]
unique_cd_unions12<-cd_unions12[!duplicated(cd_unions12[,c('RPT_ID','STATE')]),]
unique_cd_unions09<-cd_unions09[!duplicated(cd_unions09[,c('RPT_ID','STATE')]),]
unique_cd_unions11<-cd_unions11[!duplicated(cd_unions11[,c('RPT_ID','STATE')]),]
unique_cd_unions13<-cd_unions13[!duplicated(cd_unions13[,c('RPT_ID','STATE')]),]

unique_cd_unions08<-rbind(unique_cd_unions07,unique_cd_unions08,unique_cd_unions09)

unique_cd_unions10<-rbind(unique_cd_unions09,unique_cd_unions10,unique_cd_unions11)

unique_cd_unions12<-rbind(unique_cd_unions11,unique_cd_unions12,unique_cd_unions13)

date08<-read.csv('C:/Users/wooki/OneDrive/Data/new/electiondates/pdate08.csv')
date10<-read.csv('C:/Users/wooki/OneDrive/Data/new/electiondates/pdate10.csv')
date12<-read.csv('C:/Users/wooki/OneDrive/Data/new/electiondates/pdate12.csv')

uspending07<-read.csv('C:/Users/wooki/OneDrive/Data/new/lmforms/2007/ar_disbursements_genrl_data_2007.csv')
uspending08<-read.csv('C:/Users/wooki/OneDrive/Data/new/lmforms/2008/ar_disbursements_genrl_data_2008.csv')
uspending10<-read.csv('C:/Users/wooki/OneDrive/Data/new/lmforms/2010/ar_disbursements_genrl_data_2010.csv',stringsAsFactors = FALSE)
uspending12<-read.csv('C:/Users/wooki/OneDrive/Data/new/lmforms/2012/ar_disbursements_genrl_data_2012.csv')


uspending09<-read.csv('C:/Users/wooki/OneDrive/Data/new/lmforms/2009/ar_disbursements_genrl_data_2009.csv')
uspending11<-read.csv('C:/Users/wooki/OneDrive/Data/new/lmforms/2011/ar_disbursements_genrl_data_2011.csv',stringsAsFactors = FALSE)
uspending13<-read.csv('C:/Users/wooki/OneDrive/Data/new/lmforms/2013/ar_disbursements_genrl_data_2013.csv',stringsAsFactors = FALSE)


uspending08<-rbind(uspending07,uspending08,uspending09)

uspending10<-rbind(uspending09,uspending10,uspending11)

uspending12<-rbind(uspending11,uspending12,uspending13)


library(dplyr)
uspending08$RPT_ID<-as.factor(uspending08$RPT_ID)
uspending10$RPT_ID<-as.factor(uspending10$RPT_ID)
uspending12$RPT_ID<-as.factor(uspending12$RPT_ID)

unique_cd_unions08$RPT_ID<-as.factor(unique_cd_unions08$RPT_ID)
unique_cd_unions10$RPT_ID<-as.factor(unique_cd_unions10$RPT_ID)
unique_cd_unions12$RPT_ID<-as.factor(unique_cd_unions12$RPT_ID)

combined08<-left_join(uspending08,unique_cd_unions08,by = 'RPT_ID')
combined10<-left_join(uspending10,unique_cd_unions10,by = 'RPT_ID')
combined12<-left_join(uspending12,unique_cd_unions12,by = 'RPT_ID')

#drop if before primary by date
combined08_p<-left_join(combined08,date08,by = c("STATE" = "stabb"))
combined10_p<-left_join(combined10,date10,by = c("STATE" = "stabb"))
combined12_p<-left_join(combined12,date12,by = c("STATE" = "stabb"))


###method 2: date defining; when primary campaign start
combined08_p$DATE<-as.Date(combined08_p$DATE,"%m/%d/%Y")
combined08_p$ballotaccess<-as.Date(combined08_p$ballotaccess,"%m/%d/%Y")
combined10_p$DATE<-as.Date(combined10_p$DATE,"%m/%d/%Y")
combined10_p$ballotaccess<-as.Date(combined10_p$ballotaccess,"%m/%d/%Y")
combined12_p$DATE<-as.Date(combined12_p$DATE,"%m/%d/%Y")
combined12_p$ballotaccess<-as.Date(combined12_p$ballotaccess,"%m/%d/%Y")



combined08_p$pri_time<-ifelse( combined08_p[,"DATE"] < combined08_p$ballotaccess,1,0)
combined10_p$pri_time<-ifelse(  combined10_p[,"DATE"]  < combined10_p$ballotaccess,1,0)
combined12_p$pri_time<-ifelse( combined12_p[,"DATE"] < combined12_p$ballotaccess,1,0)


combined08_p$political<-ifelse( combined08_p[,"DISBURSEMENT_TYPE"] == 502,1,0)
combined10_p$political<-ifelse( combined10_p[,"DISBURSEMENT_TYPE"] == 502,1,0)
combined12_p$political<-ifelse( combined12_p[,"DISBURSEMENT_TYPE"] == 502,1,0)


combined08_p$PURPOSE<-tolower(combined08_p$PURPOSE)
combined10_p$PURPOSE<-tolower(combined10_p$PURPOSE)
combined12_p$PURPOSE<-tolower(combined12_p$PURPOSE)



combined08_p$direct_money1<-ifelse(grepl("contrib",combined08_p$PURPOSE ,fixed=T),1,0)
table(combined08_p$direct_money1)
combined08_p$direct_money2<-ifelse(grepl("lobb",combined08_p$PURPOSE ,fixed=T),1,0)
table(combined08_p$direct_money2)
combined08_p$direct_money3<-ifelse(grepl("dona",combined08_p$PURPOSE ,fixed=T),1,0)
table(combined08_p$direct_money3)

combined10_p$direct_money1<-ifelse(grepl("contrib",combined10_p$PURPOSE ,fixed=T),1,0)
table(combined10_p$direct_money1)
combined10_p$direct_money2<-ifelse(grepl("lobb",combined10_p$PURPOSE ,fixed=T),1,0)
table(combined10_p$direct_money2)
combined10_p$direct_money3<-ifelse(grepl("dona",combined10_p$PURPOSE ,fixed=T),1,0)
table(combined10_p$direct_money3)

combined12_p$direct_money1<-ifelse(grepl("contrib",combined12_p$PURPOSE ,fixed=T),1,0)
table(combined12_p$direct_money1)
combined12_p$direct_money2<-ifelse(grepl("lobb",combined12_p$PURPOSE ,fixed=T),1,0)
table(combined12_p$direct_money2)
combined12_p$direct_money3<-ifelse(grepl("dona",combined12_p$PURPOSE ,fixed=T),1,0)
table(combined12_p$direct_money3)


combined08_p$direct_money<-ifelse( combined08_p[,"direct_money1"] == 1|
                                     combined08_p[,"direct_money2"] == 1|
                                     combined08_p[,"direct_money3"] == 1 ,1,0)
combined10_p$direct_money<-ifelse( combined10_p[,"direct_money1"] == 1|
                                     combined10_p[,"direct_money2"] == 1|
                                     combined10_p[,"direct_money3"] == 1 ,1,0)
combined12_p$direct_money<-ifelse( combined12_p[,"direct_money1"] == 1|
                                     combined12_p[,"direct_money2"] == 1|
                                     combined12_p[,"direct_money3"] == 1 ,1,0)

combined08_p$indirect_money<-ifelse( combined08_p[,"direct_money"] != 1,1,0)
combined10_p$indirect_money<-ifelse( combined10_p[,"direct_money"] != 1,1,0)
combined12_p$indirect_money<-ifelse( combined12_p[,"direct_money"] != 1,1,0)

combined08_p$political_primary_direct<-ifelse( combined08_p[,"political"] == 1&
                                                 combined08_p[,"pri_time"] == 1&
                                                 combined08_p[,"direct_money"] == 1,1,0)
combined10_p$political_primary_direct<-ifelse( combined10_p[,"political"] == 1&
                                                 combined10_p[,"pri_time"] == 1&
                                                 combined10_p[,"direct_money"] == 1 ,1,0)
combined12_p$political_primary_direct<-ifelse( combined12_p[,"political"] == 1&
                                                 combined12_p[,"pri_time"] == 1&
                                                 combined12_p[,"direct_money"] == 1 ,1,0)

combined08_p$political_primary_indirect<-ifelse( combined08_p[,"political"] == 1&
                                                   combined08_p[,"pri_time"] == 1&
                                                   combined08_p[,"indirect_money"] == 1,1,0)
combined10_p$political_primary_indirect<-ifelse( combined10_p[,"political"] == 1&
                                                   combined10_p[,"pri_time"] == 1&
                                                   combined10_p[,"indirect_money"] == 1 ,1,0)
combined12_p$political_primary_indirect<-ifelse( combined12_p[,"political"] == 1&
                                                   combined12_p[,"pri_time"] == 1&
                                                   combined12_p[,"indirect_money"] == 1 ,1,0)

table(combined08_p$political_primary_indirect)
table(combined10_p$political_primary_indirect)
table(combined12_p$political_primary_indirect)


combined08_p$political_primary<-ifelse( combined08_p[,"political"] == 1&
                                          combined08_p[,"pri_time"] == 1 ,1,0)
combined10_p$political_primary<-ifelse( combined10_p[,"political"] == 1&
                                          combined10_p[,"pri_time"] == 1 ,1,0)
combined12_p$political_primary<-ifelse( combined12_p[,"political"] == 1&
                                          combined12_p[,"pri_time"] == 1 ,1,0)

table(combined08_p$political_primary)
table(combined10_p$political_primary)
table(combined12_p$political_primary)

combined08_pp<-subset(combined08_p,political_primary==1)
combined10_pp<-subset(combined10_p,political_primary==1)
combined12_pp<-subset(combined12_p,political_primary==1)

bind<-rbind(combined08_pp,combined10_pp,combined12_pp)


p8<-read.csv('')
library(dplyr)
p8_a<-select(p8, contri, lobb,donation, education,train, election, consult,event,other)
p8_b<-select(p8,PURPOSE)
dum<-data.frame(dummy = names(p8_a)[max.col(p8_a)])
new<-cbind(p8_b,dum)

d08<-left_join(bind,new,by='PURPOSE')

#install.packages("dummies")
library(dummies)
cate<-as.data.frame(dummy(d08$dummy, sep = "."))

d08$contri_d<-d08$AMOUNT*cate$`dummy, sep = ".").contri`
d08$lobby_d<-d08$AMOUNT*cate$`dummy, sep = ".").lobb`
d08$dona_d<-d08$AMOUNT*cate$`dummy, sep = ".").donation`
d08$edu_d<-d08$AMOUNT*cate$`dummy, sep = ".").education`
d08$train_d<-d08$AMOUNT*cate$`dummy, sep = ".").train`
d08$election_d<-d08$AMOUNT*cate$`dummy, sep = ".").election`
d08$consult_d<-d08$AMOUNT*cate$`dummy, sep = ".").consult`
d08$event_d<-d08$AMOUNT*cate$`dummy, sep = ".").event`
d08$other_d<-d08$AMOUNT*cate$`dummy, sep = ".").other`

barplot(colSums(d08[,c('contri_d','lobby_d','dona_d','edu_d','train_d','election_d','consult_d','event_d','other_d')]))

mi<-(colSums(d08[,c('contri_d','lobby_d','dona_d','edu_d','train_d',
                    'election_d','consult_d','event_d','other_d')]))/1000000

names(mi) <- c("Contributions", "Lobbying", "Donation", "Education", "Training", "Elections", "Consulting",
               "Events", "Other")





local_union<-d08
local_union$state_year<-paste(local_union$STATE,
                              local_union$YR_COVERED,sep="")
local_union$state_year_cd<-paste(local_union$state_year,
                                 local_union$cong_dist,sep="_")

local_union_ll<-local_union %>%
  group_by(state_year_cd) %>%
  summarize(localspening_contri_d = sum(contri_d, na.rm = TRUE),
            localspening_lobby_d = sum(lobby_d, na.rm = TRUE),
            localspening_dona_d = sum(dona_d, na.rm = TRUE),
            localspening_edu_d = sum(edu_d, na.rm = TRUE),
            localspening_train_d = sum(train_d, na.rm = TRUE),
            localspening_election_d = sum(election_d, na.rm = TRUE),
            localspening_consult_d = sum(consult_d, na.rm = TRUE),
            localspening_event_d = sum(event_d, na.rm = TRUE),
            localspening_other_d = sum(other_d, na.rm = TRUE))


distlevel<-read.csv('')
