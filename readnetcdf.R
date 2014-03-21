library(ncdf)

#tst.nc = open.ncdf("~/Downloads//PZ-master//results//prior.nc")
#init.nc = open.ncdf("~/Downloads//PZ-master//data//init.nc")
# obs.nc = are observations
#obs.nc = open.ncdf("~/Downloads//PZ-master//data//obs.nc")

# a text representation of ncdf files can be viewed by doing ncdump on the file
# e.g. ncdump file.nc

create_libbi_obs<-function(time.vect, data.vect){
    
    dimMyco<-dim.def.ncdf("Time","days",time.vect)
    ##dimState<-dim.def.ncdf("StateNo","count",1:50)# change to 50?
    # var.def.ncdf: name, units, dim, missval, longname,precision
    missVal<- -9999
    varCase<-var.def.ncdf("Cases_obs","per week",dimMyco,missVal,prec="integer")
    ##varPop<-var.def.ncdf("Pop","count",dimState,-1,longname="Population",prec="integer")
    myco_nc<-create.ncdf("~/Dropbox/Scripts/MycoLibbi/data/obs.nc",varCase)
    ##ncnew<-create.ncdf("~/Downloads/state_populations.nc",varPop)
    
    for(i in 1:length(data.vect)){
      case_count<-data.vect[i]
      put.var.ncdf(myco_nc,varCase,case_count,start=i,count=1)
    }
    
    #popAlabama<-4447100
    ## add 'popAlabama' to variable varPop, in ncnew file at position 1
    #put.var.ncdf(ncnew,varPop,popAlabama,start=1,count=1)
    ## do this in a loop - with artifical population sizes
    #for(i in 1:50){
    #  popSize<-i*100
    #  put.var.ncdf(ncnew,varPop,popSize,start=i,count=1)
    #}
    #close.ncdf(ncnew)
    
    close.ncdf(myco_nc)
    
}

# function to create libbi file with initial conditions in it
create_libbi_init<-function(){

}

t.vect<-c(-7, 1, 8, 15, 22, 29, 36, 43, 50, 57, 64, 71, 78, 85, 92, 99)
y.vect<-c(0, 3, 4, 2, 6, 10, 8, 9, 19, 17, 7, 3, 1, 3, 2, 0)

create_libbi_obs(t.vect,y.vect)
