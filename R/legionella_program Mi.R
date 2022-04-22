library(ggplot2)
library(gridExtra)
library(dplyr)
library(zipcodeR)
library(scales)

data=read.csv("F:/Spring 2022/EMD563 Lab and field studies/Valid Data/data_integrate2.csv")
colnames(data)=c("id","city","zip","use","commission_date","last_legionella_date","exceedance")

data$commission_date=as.Date(data$commission_date)

data$last_legionella_date=as.Date(data$last_legionella_date)

data=filter(data,last_legionella_date>"2015-01-01")

for (i in 1:dim(data)[1]){
  data[i,8]=reverse_zipcode(data[i,3])$county
  data[i,9]=reverse_zipcode(data[i,3])$state
}

colnames(data)[8]="county"

colnames(data)[9]="state"

legionella_pos=filter(data,exceedance=="yes")

legionella_neg=filter(data,exceedance=="no")

#sample number by month
Date.bymonth=cut(data$last_legionella_date,breaks="months")

bDates=as.data.frame(table(Date.bymonth))

bDates=bDates[which(bDates$Freq!=0),]

bDates=bDates[which(as.Date(bDates$Date.bymonth)>as.Date("2017-7-1")),]

plot(bDates$Date.bymonth,bDates$Freq)

ggplot(bDates,aes(Date.bymonth,Freq))+geom_point()+ggtitle("#of samples by month")+
  geom_text(aes(label=Freq),hjust = -0.1, nudge_x = 0.05)

ggplot(bDates, aes(x=Date.bymonth, y=Freq))+geom_bar(stat="identity")+coord_flip()+
  ggtitle("#of samples by month")

#positive counts by month
positive=read.csv("F:/Spring 2022/EMD563 Lab and field studies/positive.csv")

colnames(positive)=c("month","counts")

positive$month=as.Date(positive$month)

ggplot(positive,aes(month,counts))+geom_line()+geom_point(size=4,shape=20)+
  ggtitle("#positive by month")+geom_text(aes(label=counts),hjust = -0.1, nudge_x = 0.05)

ggplot(positive, aes(x=month, y=counts))+geom_bar(stat="identity")+
  geom_text(aes(label=counts),size=4,vjust=-0.5)+ggtitle("#of positive samples by month")

#proportion of positive by month

p_pos=data.frame()

for (i in 1:dim(bDates)[1]){
  if (bDates[i,2]!=0){
    p_pos=rbind(p_pos,c(as.character(bDates[i,1]),positive[i,2]/bDates[i,2]))
  }
  else{
    p_pos=rbind(p_pos,c(as.character(bDates[i,1]),0))
  }
}
colnames(p_pos)=c("month","p")
p_pos$percentage=percent(as.numeric(p_pos$p),0.01)
ggplot(p_pos, aes(x=month, y=percentage))+geom_bar(stat="identity")+coord_flip()+
  geom_text(aes(label=percentage),size=4,vjust=-0.5)+ggtitle("proportion of positive samples by month")

#Total sampling interval
sampling_interval=data.frame()
for (i in 2:range(length(data[,1]))){
  if (data[i,1]==data[i-1,1]){
    interval=as.numeric(as.Date(data[i,6])-as.Date(data[i-1,6]))
    sampling_interval=rbind(sampling_interval,c(data[i,1],interval))
  }
}
colnames(sampling_interval)=c("id","interval")
mean(as.numeric(sampling_interval[,2])) #135.6387 days
median(as.numeric(sampling_interval[,2])) #88 days
#interval of positive to negative
pos_neg_interval=data.frame()
first_pos=legionella_pos[which(duplicated(legionella_pos[,1])==FALSE),]
for (i in 1:length(first_pos[,1])){
  pos_id=first_pos[i,1]
  pos_date=first_pos[i,6]
  first_neg_after_pos=which(data$id==pos_id & 
                              data$last_legionella_date>pos_date & 
                              data$exceedance=="no")[1]
  neg_date=data[first_neg_after_pos,6]
  interval=as.numeric(as.Date(neg_date)-as.Date(pos_date))
  pos_neg_interval=rbind(pos_neg_interval,c(pos_id,interval))
}
mean(na.omit(pos_neg_interval[,2])) #88.28049
median(na.omit(pos_neg_interval[,2])) #22

#Counties of positive records
pos_county=as.data.frame(table(first_pos$county))
ggplot(pos_county, aes(x=Var1, y=Freq))+geom_bar(stat="identity")+coord_flip()+
  geom_text(aes(label=Freq),size=4,vjust=-0.5)+ggtitle("Counties of positive records")
#Age of positive cooling towers
first_pos[,10]=as.numeric(as.Date(first_pos$last_legionella_date)-as.Date(first_pos$commission_date))/365
colnames(first_pos)[10]=c("Service age")
mean(na.omit(first_pos$`Service age`))
median(na.omit(first_pos$`Service age`))

#towers with multiple positive records(wait to adjust)
multiple_pos=data[which(data$id==c(7,854,861,3231,3924,5110,5121,6852,7158,7215,7807,7808,8232,10213,11866,13366)),]
county_multipos=as.data.frame(table(multiple_pos$county))


#New tower
unique=data[which(duplicated(data[,1])==FALSE),]
new_bymonth=as.data.frame(table(cut(unique$last_legionella_date,breaks="months")))
colnames(new_bymonth)=c("month","new_towers")
ggplot(new_bymonth, aes(x=month, y=new_towers))+geom_bar(stat="identity")+coord_flip()+
  geom_text(aes(label=new_towers),size=4,vjust=-0.5)+ggtitle("#new towers into study by month")






#Geocode the ZIPs using the geocode_zip() function and merge the coordinates back in with the ZIPs

#```{r}
#data(zip_code_db, package='zipcodeR')
#coord1 <- geocode_zip(unique(cases$Zip))
#cases2 <- merge(cases, zip_code_db[,c('zipcode','lat','lng','population')], 
#                by.x='Zip', by='zipcode')
#```
#d2<- d2 %>%
#  tidyr::complete(week.date=seq.Date(min(week.date, na.rm=T), max(week.date, na.rm=T), 'week'), fill=list(a00_a09=0)) #fills 0s

